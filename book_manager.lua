-- book_manager.lua

local command = ARGV[1]

if command == "add" then
    local isbn = ARGV[2]
    local title = ARGV[3]
    local author = ARGV[4]
    local year = ARGV[5]

    -- Check if the book already exists
    if redis.call("EXISTS", "book:" .. isbn) == 1 then
        return "Book with ISBN " .. isbn .. " already exists."
    end

    -- Add the book
    redis.call("HMSET", "book:" .. isbn, "title", title, "author", author, "year", year)
    return "Book added successfully."

elseif command == "get" then
    local isbn = ARGV[2]
    local book = redis.call("HGETALL", "book:" .. isbn)

    if next(book) == nil then
        return "Book with ISBN " .. isbn .. " not found."
    end

    return book

elseif command == "list" then
    local keys = redis.call("KEYS", "book:*")
    local books = {}

    for _, key in ipairs(keys) do
        local book = redis.call("HGETALL", key)
        table.insert(books, book)
    end

    return books

else
    return "Invalid command. Use 'add', 'get', or 'list'."
end
