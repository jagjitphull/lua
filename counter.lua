-- Define the main function for incrementing a counter
local function increment_counter(key, increment)
    print("Starting script")  -- Debug print for logging

    -- Initialize or get the current value
    local current = tonumber(redis.call("GET", key) or "0")
    print("Current value: " .. current)  -- Log current value

    -- Increment the value
    local new_value = current + increment
    print("New value after increment: " .. new_value)  -- Log new value

    -- Set the new value in Redis
    redis.call("SET", key, new_value)
    print("Counter updated")  -- Log update confirmation

    return new_value  -- Return the new value
end

-- Call the function (for testing outside Redis)
local key = "my_counter"
local increment = 5
local result = increment_counter(key, increment)
print("Script result:", result)
