# Minecraft PS1 (PSX) Shaders
A Minecraft shader pack for both [OptiFine](https://optifine.net/) and [Iris](https://irisshaders.net/) that mimics the look and feel of PlayStation 1 graphics.

## Video Demonstration
<a href="https://www.youtube.com/watch?v=6n_WGBEuRGY" target="_blank"><strong>PlayStation 1 Graphics in Minecraft (Minecraft PSX Shader Pack)</strong><br><img src="https://img.youtube.com/vi/6n_WGBEuRGY/maxresdefault.jpg" width="640"></a>

## Installation
Clone this Git repository (if you want the latest changes), or download the latest zipped release.

Place the cloned repository folder or downloaded zip file in your `shaderpacks` folder.

**※ NOTE:** If you don't know where your `shaderpacks` folder is located, you can open it using the "Shaders Folder" button (OptiFine) or the "Open Shader Pack Folder…" button (Iris) on the bottom left of your shader pack selection screen.

## Known Issues
* Beacon beams tilt and do weird things when terrain vertex snapping is on due to [OptiFine issue #4905](https://github.com/sp614x/optifine/issues/4905).  If anyone knows the block entity ID of beacon beams or whatever it is to single it out in gbuffers_block, please let me know.

* Texture affine map clamping ("Clamp Texcoord Bounds (OptiFine only)") is disabled by default in order to ensure that texture affine mapping works at all for Iris users. OptiFine users may want to re-enable this option in order to avoid extreme texture stretching on some geometry close to the camera at certain angles.
	* The reason why this feature is broken is because it requires the use of a custom GLSL uniform (`texelSize`), but custom uniforms are not supported on Iris yet — see [Iris issue #1027](https://github.com/IrisShaders/Iris/issues/1027).

* Texture affine mapping behaviour on Iris does not exactly match that of OptiFine's. All affine mapped textures on Iris warp in the opposite direction compared to OptiFine, though this is not noticeable without comparing the two side-by-side.

## License
Licensed under the [MIT License](https://choosealicense.com/licenses/mit/).
