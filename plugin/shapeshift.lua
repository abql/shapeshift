vim.api.nvim_create_user_command('Shape', 'lua Shapeshift(<f-args>)', {range = 0, nargs = '*'})

function MaxDepth(line, sign)
    local cursor = 1
	local max_depth = 0

    for i = 1, #line do
        local char = string.sub(line, i, i)
        if char == sign then
            if cursor > max_depth then
                max_depth = cursor
            end
			goto continue
        end
		cursor = cursor + 1
    end

	::continue::
	return max_depth
end

function Replacement(real_lines, depth, sign, spacing)
    local cursor = 1
    local message = {}

    for _, line in ipairs(real_lines) do
		local current_line = ""
        for i = 1, #line do
            local char = string.sub(line, i, i)

			if char == sign then
				while cursor < depth do
					current_line = current_line .. " "
					cursor = cursor + 1
				end
				if spacing ~= nil then
					for _ = 1, spacing do
						current_line = current_line .. " "
					end
				end
			end

            current_line = current_line .. char
            cursor = cursor + 1
        end

		table.insert(message, current_line)
		cursor = 1
    end

    return message
end

function Shapeshift(...)
	local start_line = vim.fn.line("'<")
	local end_line   = vim.fn.line("'>")
	local real_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local depth      = 0
	local arguments  = {...}
	local sign       = arguments[1] or "="
	local spacing    = arguments[2]

	for _, line in ipairs(real_lines) do
		if depth < MaxDepth(line, sign) then
			depth = MaxDepth(line, sign)
		end
	end

	local repl = Replacement(real_lines, depth, sign, tonumber(spacing))
	local repl_lines = {}
    for _, str in ipairs(repl) do
        for line in str:gmatch("[^\r\n]+") do
            table.insert(repl_lines, line)
        end
    end

	vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, repl_lines)
end
