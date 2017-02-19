# SwiftIOSANE  

Example Xcode project showing how to programme Air Native Extensions for iOS using Swift.

### Help Wanted !

The ANE currently runs on the Simulator only
The package is created and successfully deployed to device.
However it crashes with either these errors: 
1. code signing blocked mmap()
2. required code signature missing for '/private/var/containers/Bundle/Application/86FFE565-CBC9-4B19-A41F-169C8E98630C/Main_Swift.app/SwiftIOSANE_FW.framework/SwiftIOSANE_FW'

This is due I believe to the Swift Framework needing to be signed as part of packaging process. I am not able to find a suitable way to do this without resigning the whole pacakge.
If you are familiar with such problems please give me a shout.

### Prerequisites

You will need
 
 - Xcode 8.2 / AppCode
 - IntelliJ IDEA
 - AIR 25 Beta SDK

