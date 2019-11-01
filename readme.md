# MVVM Playground, a photo showcase app.

This is a sample code for MVVM with dependency injection playground.

```
.
├── Module
│   ├── PhotoDetail
│   │   └── PhotoDetailViewController.swift
│   ├── PhotoListWithMVC
│   │   ├── PhotoListTableViewCellWithMVC.swift
│   │   └── PhotoListViewControllerWithMVC.swift
│   └── PhotoListWithMVVM
│       ├── PhotoListTableViewCell.swift
│       ├── PhotoListViewController.swift
│       └── ViewModel
│           ├── PhotoListCellViewModel.swift
│           ├── PhotoListViewModel.swift
│           └── State.swift
├── Service
│   ├── APIService.swift
│   └── content.json
├── Model
│   └── photo.swift
├── Others
│   ├── AppDelegate.swift
│   ├── Assets.xcassets
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   └── Contents.json
│   ├── Base.lproj
│   │   ├── LaunchScreen.storyboard
│   │   └── Main.storyboard
│   └── Info.plist
```

The app will run the PhotoListWithMVVM code by default, if you want to run the PhotoListWithMVC you should add the below files to MVVMPlayground Target (by checking the box in the target membership section for both files).

* PhotoListTableViewCellWithMVC.swift
* PhotoListViewControllerWithMVC.swift

and change the custom  class of Photo List View Controller in the Main.storyboard to PhotoListTableViewCellWithMVC.
