-- Create sequences

CREATE SEQUENCE customers_id_seq;
CREATE SEQUENCE suppliers_id_seq;
CREATE SEQUENCE products_id_seq;
CREATE SEQUENCE shippers_id_seq;
CREATE SEQUENCE orders_id_seq;
CREATE SEQUENCE deliveries_id_seq;
CREATE SEQUENCE supplies_id_seq;
CREATE SEQUENCE warehouses_id_seq;

-- Create the tables

CREATE TABLE customers (
  id INTEGER DEFAULT nextval('customers_id_seq') PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  city VARCHAR(255),
  postal_code VARCHAR(20),
  country VARCHAR(255),
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  registration_date DATE
);

CREATE TABLE categories (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  image_url VARCHAR(255),
  description TEXT,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE suppliers (
  id INTEGER DEFAULT nextval('suppliers_id_seq') PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255),
  city VARCHAR(255),
  postal_code VARCHAR(20),
  country VARCHAR(255),
  phone_number VARCHAR(50)
);

CREATE TABLE products (
  id INTEGER DEFAULT nextval('products_id_seq') PRIMARY KEY,
  supplier_id INTEGER REFERENCES suppliers(id),
  category_id INTEGER REFERENCES categories(id),
  name VARCHAR(255) NOT NULL,
  subcategory VARCHAR(50),
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  stock_qty INTEGER,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE shippers (
  id INTEGER DEFAULT nextval('shippers_id_seq') PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  phone_number VARCHAR(50)
);

CREATE TABLE orders (
  id INTEGER DEFAULT nextval('orders_id_seq') PRIMARY KEY,
  customer_id INTEGER REFERENCES customers(id),
  ordered_at TIMESTAMP NOT NULL
);

CREATE TABLE orders_details (
  order_id INTEGER REFERENCES orders(id),
  product_id INTEGER REFERENCES products(id),
  item_qty INTEGER NOT NULL,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id, product_id)
);

CREATE TABLE deliveries (
  id INTEGER DEFAULT nextval('deliveries_id_seq') PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id),
  shipper_id INTEGER REFERENCES shippers(id),
  status VARCHAR(50) NOT NULL,
  description TEXT,
  location VARCHAR(100),
  scan_time TIMESTAMP,
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Add foreign key constraints (already specified in REFERENCES above)

-- ALTER TABLE orders
--   ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
--   ADD CONSTRAINT fk_orders_shipper FOREIGN KEY (shipper_id) REFERENCES shippers(id);
--
-- ALTER TABLE orders_details
--   ADD CONSTRAINT fk_order_details_order FOREIGN KEY (order_id) REFERENCES orders(id),
--   ADD CONSTRAINT fk_order_details_product FOREIGN KEY (product_id) REFERENCES products(id);
--
-- ALTER TABLE products
--   ADD CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id),
--   ADD CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(id);
--
-- ALTER TABLE supplies
--   ADD CONSTRAINT fk_supplies_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
--   ADD CONSTRAINT fk_supplies_product FOREIGN KEY (product_id) REFERENCES products(id);
--
-- ALTER TABLE storage
--   ADD CONSTRAINT fk_storage_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouses(id),
--   ADD CONSTRAINT fk_storage_product FOREIGN KEY (product_id) REFERENCES products(id);
