Locales = Locales or {}

function _t(str, ...)
    if Locales['en'] and Locales['en'][str] then
        return string.format(Locales['en'][str], ...)
    end
    return str
end

function Lang(str, ...)
    return _t(str, ...)
end
