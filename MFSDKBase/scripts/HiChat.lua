function didTapCell(param)

    local navigationController = UIApplication:sharedApplication():keyWindow():rootViewController()
    if navigationController then
        local viewController = MFViewController:initWithScriptName("Balance")
        navigationController:pushViewController_animated(viewController,toobjc(true))
    else
        wax.alert("navigationController is null", "navigationController")
    end

    return wax.json.generate({param=param})

end

function onClickHeadView(param)
local navigationController = UIApplication:sharedApplication():keyWindow():rootViewController()
if navigationController then
navigationController:popToRootViewControllerAnimated(YES)
else
wax.alert("navigationController is null", "navigationController")
end

return wax.json.generate({param=param})

end