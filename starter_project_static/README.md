### Static Frameworks are unlikely to work until AIR SDK is updated to be compiled against iOS 13

Some iOS frameworks such as Firebase do not work correctly if referenced from Dynamic Frameworks

You can use a single static Swift based lib for this.

The main caveat is that this ANE will not work in the Simulator 
