function didClickCell(param)

local navigationController = UIApplication:sharedApplication():keyWindow():rootViewController()
if navigationController then
navigationController:popToRootViewControllerAnimated(YES)
end

return wax.json.generate({param=param})

end