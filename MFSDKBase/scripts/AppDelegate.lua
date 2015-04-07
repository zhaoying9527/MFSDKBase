waxClass{"AppDelegate", protocols = {"UIApplicationDelegate"}}

function applicationDidFinishLaunching(self, application)
  local frame = UIScreen:mainScreen():bounds()
  self.window = UIWindow:initWithFrame(frame)
  self.window:setBackgroundColor(UIColor:orangeColor())


  local viewController = MFViewController:initWithScriptName("Master")
  local navController = UINavigationController:alloc():initWithRootViewController(viewController)
  self.window:setRootViewController(navController)

  self.window:makeKeyAndVisible()
end