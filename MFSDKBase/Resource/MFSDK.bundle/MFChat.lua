function didClickHeadIcon(params)
    local target = params["target"]
    local cell = target:MFViewCell()

    if cell:respondsToSelector("didClickHeadIcon:") then
        cell:didClickHeadIcon(target)
    end

    return {result=success}
end

function didDoubleClickCell(params)
    local target = params["target"]
    local cell = target:MFViewCell()

    if cell:respondsToSelector("didDoubleClickCell:") then
        cell:didDoubleClickCell(target)
    end

    return {result=success}
end

function didClickCTCell(params)
    local target = params["target"]
    local cell = target:MFViewCell()

    if cell:respondsToSelector("didClickCTCell:") then
        cell:didClickCTCell(target)
    end

    return {result=success}
end

function didLongPressCell(params)
    local target = params["target"]
    local cell = target:MFViewCell()

    if cell:respondsToSelector("didLongPressCell:") then
        cell:didLongPressCell(target)
    end

    return {result=success}
end

function retryTapedWithCell(params)
    local target = params["target"]
    local cell = target:MFViewCell()

    if cell:respondsToSelector("retryTapedWithCell:") then
        cell:retryTapedWithCell(target)
    end

    return {result=success}
end

function didClickPhoto(params)
    local target = params["target"]
    local cell = target:MFViewCell()

    if cell:respondsToSelector("didClickPhoto:") then
        cell:didClickPhoto(target)
    end

    return {result=success}
end