USE PROJECT_2;
SELECT * FROM address;
SELECT * FROM customer;
SELECT * FROM ingredient;
SELECT * FROM inventory;
SELECT * FROM item;
SELECT * FROM orders;
SELECT * FROM recipe;
SELECT * FROM rota;
SELECT * FROM shift;
SELECT * FROM staff;

# DASHBOARD 1 - ORDER ACTIVITY
# FOR THIS, WE WILL NEED A DASHBOARD WITH THE FOLLOWING DATA:

# 1. TOTAL ORDERS
SELECT COUNT(order_id) TOTAL_ORDERS
FROM orders;

# 2. TOTAL SALES
SELECT SUM(quantity)AS TOTAL_SALES
FROM orders;

# 3. TOTAL ITEMS
SELECT COUNT(item_id) AS TOTAL_ITEMS
FROM item;

# 4. AVERAGE ORDER values
SELECT AVG(quantity) AS AVG_ORDER_VALUES
FROM orders;

# 5. SALES BY CATEGORY
SELECT SUM(orders.quantity * item.item_price)AS TOTAL_SALES, item.item_cat
FROM orders
JOIN item ON item.item_id = orders.item_id
GROUP BY item.item_cat
ORDER BY TOTAL_SALES DESC;

# 6. TOP SELLING ITEMS
SELECT SUM(orders.quantity) AS total_sale,item_name
FROM orders
JOIN item ON item.item_id = orders.item_id
GROUP BY item_name
ORDER BY total_sale DESC
LIMIT 10;
# 7. ORDERS BY HOUR
SELECT EXTRACT(HOUR FROM created_at) AS order_hour, COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;

# 8. SALES BY HOUR
SELECT EXTRACT(HOUR FROM created_at) AS hours, SUM(orders.quantity * item.item_price) AS SALES
FROM orders
JOIN item ON item.item_id = orders.item_id
GROUP by hours
ORDER BY hours DESC;
# 9. ORDERS BY ADDRESS
SELECT COUNT(orders.order_id) AS ORDERS, address.delivery_address1
FROM orders
JOIN address ON address.add_id = orders.add_id
GROUP BY address.delivery_address1
ORDER BY ORDERS DESC;

# 10. ORDERS BY DELIVERY
SELECT order_id
FROM orders
WHERE delivery = TRUE;

#PICK UP
SELECT order_id
FROM orders
WHERE delivery = FALSE;

# DASHBOARD 2: INVENTORY MANAGEMENT

# 1. TOTAL QUANTITY BY INGREDIENT
SELECT SUM(recipe.quantity)AS total_quantity,ingredient.ing_name
FROM recipe
JOIN ingredient ON ingredient.ing_id = recipe.ing_id
GROUP BY ingredient.ing_name
ORDER BY total_quantity DESC;

# 2. TOTAL COST OF INGREDIENT
SELECT SUM(recipe.quantity * ingredient.ing_price) AS cost_of_ing, ing_name
FROM recipe
JOIN ingredient ON ingredient.ing_id = recipe.ing_id
GROUP BY ingredient.ing_name
ORDER BY cost_of_ing DESC;

# 3. CALCULATED COST OF PIZZA
SELECT SUM(recipe.quantity * ingredient.ing_price) AS pizza_cost, recipe.recipe_id
FROM recipe
JOIN ingredient ON ingredient.ing_id = recipe.ing_id
GROUP BY recipe.recipe_id
ORDER BY pizza_cost DESC;

# 4. PERCENTAGE STOCK REMAINING BY INGREDIENT
SELECT ingredient.ing_name, (ingredient.ing_weight - SUM(recipe.quantity))/ingredient.ing_weight * 100 AS percent_remaining
FROM ingredient
JOIN recipe ON recipe.ing_id = ingredient.ing_id
GROUP BY ingredient.ing_name, ingredient.ing_weight
ORDER BY percent_remaining DESC;

