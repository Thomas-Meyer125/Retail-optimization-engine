CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    weekly_sales INT,
    profit_margin DECIMAL(5,2),
    shelf_width_inches INT,
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE shelf_constraints (
    shelf_id SERIAL PRIMARY KEY,
    total_width_inches INT
);

INSERT INTO shelf_constraints (total_width_inches)
VALUES (120);
