-- account_manager.lua

local command = ARGV[1]

if command == "add_account" then
    local account_id = ARGV[2]
    local user = ARGV[3]
    local email = ARGV[4]
    local initial_balance = tonumber(ARGV[5])

    -- Check if the account already exists
    if redis.call("EXISTS", "account:" .. account_id) == 1 then
        return "Error: Account with ID " .. account_id .. " already exists."
    end

    -- Add the new account
    redis.call("HMSET", "account:" .. account_id, "user", user, "email", email, "balance", initial_balance)
    return "Account added successfully."

elseif command == "transfer_funds" then
    local from_account_id = ARGV[2]
    local to_account_id = ARGV[3]
    local amount = tonumber(ARGV[4])

    -- Check if both accounts exist
    if redis.call("EXISTS", "account:" .. from_account_id) == 0 then
        return "Error: Source account does not exist."
    end

    if redis.call("EXISTS", "account:" .. to_account_id) == 0 then
        return "Error: Destination account does not exist."
    end

    -- Get the current balance of the source account
    local from_balance = tonumber(redis.call("HGET", "account:" .. from_account_id, "balance"))

    -- Check if the source account has sufficient funds
    if from_balance < amount then
        return "Error: Insufficient funds in source account."
    end

    -- Perform the transfer atomically
    redis.call("HINCRBYFLOAT", "account:" .. from_account_id, "balance", -amount)
    redis.call("HINCRBYFLOAT", "account:" .. to_account_id, "balance", amount)

    return "Transfer successful."

elseif command == "get_account" then
    local account_id = ARGV[2]
    local account = redis.call("HGETALL", "account:" .. account_id)

    if next(account) == nil then
        return "Error: Account with ID " .. account_id .. " not found."
    end

    return account

else
    return "Error: Invalid command. Use 'add_account', 'transfer_funds', or 'get_account'."
end

--[[
FOR ATOMICITY

Load the Script into Redis:
$ redis-cli SCRIPT LOAD "$(cat accounts_transfer_funds.lua)"

Add a New Account
$ redis-cli EVALSHA <SHA1_HASH> 0 add_account 12345 "John Doe" "john.doe@example.com" 1000.00
$ redis-cli EVALSHA 22c70bb9a5bb57d07f7ebe3b440922671936760a 0 add_account 54321  "Jrp" "jrp@example.com" 2000.00

Transfer Funds:
$ redis-cli EVALSHA <SHA1_HASH> 0 transfer_funds 12345 67890 250.00

Retrieve Account Details:
$ redis-cli EVALSHA <SHA1_HASH> 0 get_account 12345




]]
