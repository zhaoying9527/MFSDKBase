function onClickImageView(param)

  wax.alert("Click ImageView", "Click ImageView")

  return wax.json.generate({param=param})

end

function didSelectCell(param)

    local navigationController = UIApplication:sharedApplication():keyWindow():rootViewController()
    if navigationController then
    local viewController = MFViewController:initWithScriptName("Detail")
    navigationController:pushViewController_animated(viewController,toobjc(true))
    else
    wax.alert("navigationController is null", "navigationController")
    end

    return wax.json.generate({param=param})

end