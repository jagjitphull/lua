-- Redis Lua script for managing a collection of books with logging

--[[
In Redis, with logging functionality for debugging, can be done by leveraging Redis commands within Lua. 
Redis offers support for Lua scripting, so you can define functions like adding, fetching, updating, and deleting books in a Lua script that Redis can execute. 
Logging can be achieved by storing log entries in a Redis list.
]]

-- Function to log messages to a Redis list for debugging
local function log(message)
    local log_key = "book_logs"
    redis.call("RPUSH", log_key, message)
end

-- Function to add a new book
local function add_book(book_id, title, author, year)
    local book_key = "book:" .. book_id

    -- Check if the book already exists
    if redis.call("EXISTS", book_key) == 1 then
        log("Attempted to add a book that already exists: " .. book_id)
        return "Book with this ID already exists."
    end

    -- Add book details
    redis.call("HMSET", book_key, "title", title, "author", author, "year", year)
    log("Book added with ID: " .. book_id)
    return "Book added successfully."
end

-- Function to get book details
local function get_book(book_id)
    local book_key = "book:" .. book_id

    -- Check if the book exists
    if redis.call("EXISTS", book_key) == 0 then
        log("Attempted to fetch a non-existent book: " .. book_id)
        return "Book not found."
    end

    -- Fetch and return book details
    local book_details = redis.call("HGETALL", book_key)
    log("Fetched details for book ID: " .. book_id)
    return book_details
end

-- Function to update a book
local function update_book(book_id, title, author, year)
    local book_key = "book:" .. book_id

    -- Check if the book exists
    if redis.call("EXISTS", book_key) == 0 then
        log("Attempted to update a non-existent book: " .. book_id)
        return "Book not found."
    end

    -- Update book details
    redis.call("HMSET", book_key, "title", title, "author", author, "year", year)
    log("Book updated with ID: " .. book_id)
    return "Book updated successfully."
end

-- Function to delete a book
local function delete_book(book_id)
    local book_key = "book:" .. book_id

    -- Check if the book exists
    if redis.call("EXISTS", book_key) == 0 then
        log("Attempted to delete a non-existent book: " .. book_id)
        return "Book not found."
    end

    -- Delete the book
    redis.call("DEL", book_key)
    log("Book deleted with ID: " .. book_id)
    return "Book deleted successfully."
end

-- Function to fetch logs for debugging
local function fetch_logs()
    return redis.call("LRANGE", "book_logs", 0, -1)
end

-- Main logic to handle commands
local command = ARGV[1]
local book_id = ARGV[2]

if command == "add" then
    return add_book(book_id, ARGV[3], ARGV[4], ARGV[5])
elseif command == "get" then
    return get_book(book_id)
elseif command == "update" then
    return update_book(book_id, ARGV[3], ARGV[4], ARGV[5])
elseif command == "delete" then
    return delete_book(book_id)
elseif command == "logs" then
    return fetch_logs()
else
    return "Invalid command."
end



--[[
Add a Book:
redis-cli --eval book_management.lua , add 1 "To Kill a Mockingbird" "Harper Lee" 1960

Get Book Details:
redis-cli --eval book_management.lua , get 1

Update a Book:
redis-cli --eval book_management.lua , update 1 "To Kill a Mockingbird" "Harper Lee" 1961

Delete a Book:
redis-cli --eval book_management.lua , delete 1

Fetch Logs:
redis-cli --eval book_management.lua , logs

]]
