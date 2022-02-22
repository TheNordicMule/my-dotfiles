function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
    return ...
end

local function reload(...)
  package.loaded[...] = nil
end

function _G.R(name)
    reload(name)
    return require(name)
end
