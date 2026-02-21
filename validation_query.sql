SELECT SUM(shelf_width_inches) AS total_optimized_width
FROM (

    WITH ranked_products AS (
        SELECT *,
               weekly_sales * profit_margin AS performance_score
        FROM products
        WHERE active = TRUE
    ),
    cereal_priority AS (
        SELECT *
        FROM ranked_products
        WHERE category = 'Cereal'
        ORDER BY performance_score DESC
        LIMIT 3
    ),
    remaining_products AS (
        SELECT *
        FROM ranked_products
        WHERE product_id NOT IN (
            SELECT product_id FROM cereal_priority
        )
    ),
    combined AS (
        SELECT * FROM cereal_priority
        UNION ALL
        SELECT * FROM remaining_products
    ),
    ordered_products AS (
        SELECT *,
               SUM(shelf_width_inches) OVER (
                   ORDER BY performance_score DESC
               ) AS cumulative_width
        FROM combined
    )
    SELECT *
    FROM ordered_products
    WHERE cumulative_width <= (
        SELECT total_width_inches
        FROM shelf_constraints
        LIMIT 1
    )

) AS optimized;
