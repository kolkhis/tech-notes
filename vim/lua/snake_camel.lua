M = {}

---Turn camelCase to snake_case, and vice versa
---@param cword string
-- local function camel_snake_toggle(cword)
M.camel_snake_toggle = function(cword)
  local camelCase = vim.regex([[^\l.*\(\u\)]]):match_str(cword)
  local snake_case = vim.regex([[^\l.*\(_\)]]):match_str(cword)
  local new_word = cword
  if snake_case then
    local index, _ = new_word:find('_')
    while index do
      local charToUpper = new_word:sub(index + 1, index + 1):upper()
      new_word = new_word:sub(1, index - 1) .. charToUpper .. new_word:sub(index + 2)
      index, _ = new_word:find('_')
      print(('new word: %s'):format(new_word))
    end
  elseif camelCase then
    local index, _ = new_word:find('%u')
    print(('is camelCase. idx: %s'):format(index))
    while index do
      local char_to_lower = new_word:sub(index, index)
      new_word = new_word:sub(1, index - 1) .. '_' .. char_to_lower:lower() .. new_word:sub(index + 1)
      index, _ = new_word:find('%u')
      print(('new word: %s'):format(new_word))
    end
  else
    return
  end
  if new_word then
    return new_word
  end
end
local snake_string = 'snake_case_string'
local camel_string = 'camelCaseString'

-- camel_snake_toggle(string(vim.fn.expand('<cword>')))
M.camel_snake_toggle(camel_string)

vim.keymap.set({ 'i', 'n' }, '<C-x>', function()
  local new_casing = M.camel_snake_toggle(vim.fn.expand('<cword>'))
  print(('new casing: %s'):format(new_casing))
  vim.cmd(('normal! viws%s'):format(new_casing))
end)

-- local function next_pos(idx)
--     if idx == start_index then
--         idx = start_index + 1
--     end
-- end

--
