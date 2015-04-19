function onClickImageView(param)

  wax.alert("Click ImageView", "Click ImageView")

  return wax.json.generate({param=param})

end

function didTapCell(param)

    local navigationController = UIApplication:sharedApplication():keyWindow():rootViewController()
    if navigationController then
    local viewController = MFViewController:initWithSceneName("Balance")
    navigationController:pushViewController_animated(viewController,toobjc(true))
    else
    wax.alert("navigationController is null", "navigationController")
    end

    return wax.json.generate({param=param})

end