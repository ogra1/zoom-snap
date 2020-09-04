[![Snap Status](https://build.snapcraft.io/badge/ogra1/zoom-snap.svg)](https://build.snapcraft.io/user/ogra1/zoom-snap)

# zoom-client snap

Video conferencing with real-time messaging and content sharing

https://zoom.us provides simplified video conferencing, whiteboard sharing
and messaging across any device. This is an unofficial re-pack of the debian
package provided by zoom.us that uses the enhanced update and security
features of the snap packaging system, more info on snap security can be 
found at:

https://snapcraft.io/docs/snap-confinement  
https://snapcraft.io/docs/security-sandboxing  
https://snapcraft.io/docs/interface-management  

The snap package also benefits from automatic updates, on-demand rollback and 
data snapshots. Details about these features can be found at:

https://snapcraft.io/docs/keeping-snaps-up-to-date  
https://snapcraft.io/docs/getting-started#heading--revert  
https://snapcraft.io/docs/snapshots  <br />

# Installing

To install the snap package, simply use
```
sudo snap install zoom-client
```
Details about installing on various distributions that do not come with snapd out of the box can be found at the bottom of https://snapcraft.io/zoom-client

# Building

To build the snap yourself, clone this github repo and run snapcraft in the top of the source tree:

```
sudo snap install snapcraft --classic
git clone https://github.com/ogra1/zoom-snap.git
cd zoom-snap
snapcraft
```
