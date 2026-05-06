# sharpening with blurr (this sharpends more details than the highpass filter method)

eyes and other parts that would be skipped using high pass filter are now sharpen properly

1. make on layer by combining all layers (select all and cmd+e)
2. copy the layer (cmd+j) (give this a name, like sharpening) ( this can probably be skipped -> filter -> convert to
   smart filter, this will allow me to change the values later on this layer)
   **we need two copies of the layer to group them later**
3. invert layer, (cmd+i)
4. blur layer, -> filter -> blur -> Guaussian blurr (set to 1.3)
5. set blend mode to overlay

   ref: https://www.youtube.com/watch?v=_IujZ_RJ61w
