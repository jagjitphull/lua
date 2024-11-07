-- stock_exchange.lua

local command = ARGV[1]

if command == "add" then
    local symbol = ARGV[2]
    local name = ARGV[3]
    local price = ARGV[4]

    -- Check if the stock already exists
    if redis.call("EXISTS", "stock:" .. symbol) == 1 then
        return "Stock with symbol " .. symbol .. " already exists."
    end

    -- Add the stock
    redis.call("HMSET", "stock:" .. symbol, "name", name, "price", price)
    return "Stock added successfully."

elseif command == "update_price" then
    local symbol = ARGV[2]
    local price = ARGV[3]

    -- Check if the stock exists
    if redis.call("EXISTS", "stock:" .. symbol) == 0 then
        return "Stock with symbol " .. symbol .. " does not exist."
    end

    -- Update the stock price
    redis.call("HSET", "stock:" .. symbol, "price", price)
    return "Stock price updated successfully."

elseif command == "get" then
    local symbol = ARGV[2]
    local stock = redis.call("HGETALL", "stock:" .. symbol)

    if next(stock) == nil then
        return "Stock with symbol " .. symbol .. " not found."
    end

    return stock

elseif command == "list" then
    local keys = redis.call("KEYS", "stock:*")
    local stocks = {}

    for _, key in ipairs(keys) do
        local stock = redis.call("HGETALL", key)
        table.insert(stocks, stock)
    end

    return stocks

else
    return "Invalid command. Use 'add', 'update_price', 'get', or 'list'."
end


--[[
redis-cli script load "$(cat stock_exchange.lua)"

Add a Stock:
$ redis-cli EVALSHA <SHA1_HASH> 0 add "AAPL" "Apple Inc." "150.00"

Update Stock Price:
$ redis-cli EVALSHA <SHA1_HASH> 0 update_price "AAPL" "155.00"

Retrieve a Stock:
$ redis-cli EVALSHA <SHA1_HASH> 0 get "AAPL"

List All Stocks:
$ redis-cli EVALSHA <SHA1_HASH> 0 list

]]
