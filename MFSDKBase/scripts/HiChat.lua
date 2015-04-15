function didTapCell(param)

    local navigationController = UIApplication:sharedApplication():keyWindow():rootViewController()

    if navigationController then
      navigationController:popViewControllerAnimated(YES)
    end

    return wax.json.generate({param=param})

end