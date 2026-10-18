# Data
orders <- data.frame(
    order_id    = 1:6,
    customer_id = c(101, 102, 101, 104, 103, 105),
    amount      = c(250, 80, 120, 60, 300, 45)
)

customers <- data.frame(
    customer_id = c(101, 102, 103, 104),
    name        = c("Alice", "Bob", "Carla", "Dave"),
    city        = c("Aberdeen", "Birmingham", "Cardiff", "Durham"),
    stringsAsFactors = FALSE
)

orders
customers

# Option 1: with lookup vectors (names = the key, values = the value)

name_lookup <- customers$name
names(name_lookup) <- customers$customer_id

city_lookup <- customers$city
names(city_lookup) <- customers$customer_id

name_lookup
city_lookup

# name_lookup <- setNames(customers$name, nm = customers$customer_id)
# city_lookup <- setNames(customers$city, customers$customer_id)


name_lookup[orders$customer_id]
name_lookup[as.character(orders$customer_id)]
unname(name_lookup[as.character(orders$customer_id)])

orders_res_lkp <- orders
orders_res_lkp$name <- unname(name_lookup[as.character(orders$customer_id)])

orders_res_lkp$city <- unname(city_lookup[as.character(orders$customer_id)])
orders_res_lkp

# Option 2: with merge
orders_res_merge <- merge(orders, customers, by = "customer_id")
orders_res_merge

orders_res_merge <- merge(orders, customers, by = "customer_id", all.x = TRUE)
orders_res_merge
