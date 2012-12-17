# BDKNotifyHUD

## Overview

Displays a translucent-ish modal over with an image and a label; largely customizable, yet simple.

## Usage

``` objective-c
// Create the HUD object; view can be a UIImageView, an icon... you name it
BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithView:[UIView someCustomView]
                                               text:@"This is a checkmark!"];
hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);

// Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
[self.view addSubview:hud];
[hud presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
    [hud removeFromSuperview];
}];
```

For more usage, checkout the sample project included in this repo.

## Contributions

I'd love your contributions! Send me your fixes in pull requests, and if they check out okay, I'll merge them.
