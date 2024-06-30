import time
import random
import pandas as pd
from sqlalchemy import create_engine
from faker import Faker

# Constants
DATABASE_URL = 'postgresql://postgres:1234@localhost:5432/postgres'
NUM_ORDERS = 10  # Number of orders to generate
MIN_DELAY_MS = 1000
MAX_DELAY_MS = 1500

# Initialize Faker
fake = Faker()

# Database engine
engine = create_engine(DATABASE_URL)


# Utility function to generate random delay
def random_delay(min_ms, max_ms):
    delay = random.uniform(min_ms, max_ms) / 1000.0  # Convert milliseconds to seconds
    time.sleep(delay)


# Function to fetch existing IDs from the database
def fetch_existing_ids(table_name, column_name):
    query = f'SELECT {column_name} FROM {table_name}'
    return pd.read_sql(query, engine)[column_name].tolist()


# Function to generate orders data
def generate_orders_data(customer_ids):
    orders_data = []
    for _ in range(NUM_ORDERS):
        orders_data.append({
            'customer_id': random.choice(customer_ids),
            'ordered_at': fake.date_time_between(start_date='-1y', end_date='now'),
        })
    return pd.DataFrame(orders_data)


# Function to generate orders details data
def generate_orders_details_data(order_ids, product_ids):
    orders_details_data = []
    for order_id in order_ids:
        for _ in range(random.randint(1, 5)):  # Each order can have 1 to 5 products
            orders_details_data.append({
                'order_id': order_id,
                'product_id': random.choice(product_ids),
                'item_qty': random.randint(1, 10),
                'last_updated': fake.date_time_between(start_date='-1y', end_date='now')
            })
    return pd.DataFrame(orders_details_data)


# Function to generate deliveries data
def generate_deliveries_data(order_ids, shipper_ids):
    delivery_statuses = [
        'In Transit', 'Arrived at Overseas', 'Item is Pre-Advised', 'Poste Restante',
        'Arrival Scan', 'Redirected', 'Out for Delivery', 'Cleared Customs',
        'Unsuccessful Delivery Attempt', 'Returned Back to Sender'
    ]
    deliveries_data = []
    for order_id in order_ids:
        num_statuses = random.randint(1, 5)  # Each order can have 1 to 5 status updates
        for _ in range(num_statuses):
            deliveries_data.append({
                'order_id': order_id,
                'shipper_id': random.choice(shipper_ids),
                'status': random.choice(delivery_statuses),
                'description': fake.text(max_nb_chars=200),
                'location': fake.city(),
                'scan_time': fake.date_time_between(start_date='-1y', end_date='now'),
                'last_updated': fake.date_time_between(start_date='-1y', end_date='now')
            })
    return pd.DataFrame(deliveries_data)


# Function to insert DataFrame into SQL table
def insert_data_to_sql(df, table_name):
    df.to_sql(name=table_name, con=engine, if_exists='append', index=False)


# Main function to generate and insert data
def main():
    customer_ids = fetch_existing_ids('customers', 'id')
    shipper_ids = fetch_existing_ids('shippers', 'id')
    product_ids = fetch_existing_ids('products', 'id')

    while True:
        # Generate data
        df_orders = generate_orders_data(customer_ids)
        insert_data_to_sql(df_orders, 'orders')

        order_ids = fetch_existing_ids('orders', 'id')
        df_orders_details = generate_orders_details_data(order_ids, product_ids)
        insert_data_to_sql(df_orders_details, 'orders_details')

        df_deliveries = generate_deliveries_data(order_ids, shipper_ids)
        insert_data_to_sql(df_deliveries, 'deliveries')

        # Wait for a random delay
        random_delay(MIN_DELAY_MS, MAX_DELAY_MS)


# Run the main function
if __name__ == "__main__":
    main()
