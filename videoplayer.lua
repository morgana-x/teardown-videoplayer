monitor = nil

selectedVideo = "badapple"
currentAudio = nil --  LoadLoop(selectedVideo ..'.mp3')
currentFrameSprite =  nil -- LoadSprite(selectedVideo .. "/frame1")
currentFrame = 1
endFrame = 5257
framerate = 26
nextFrame = 0
nextRender = 0

selectedVideo = GetStringParam("video", "badapple")
function init()
 
    monitor = FindShape('screen')

    if monitor == 0 then
        monitor = FindBody('screen')
    end
    loadVideo(selectedVideo)
end


local frames = {
    
}
local video_data = {
    ["badapple"] = {
        fps = 26,
        frames = 5257,
        format = ".png"
    },
    ["hazehaze"] = {
        fps = 12,
        frames = 2950,
        format = ".jpg"
    }
}
function loadVideo(video)
    selectedVideo = video
    currentAudio = LoadLoop("snd/" .. selectedVideo ..'/audio.ogg')
    currentFrameSprite = LoadSprite("image/" .. selectedVideo .. "/frame1" .. video_data[video].format)
    currentFrameString = "image/" .. selectedVideo .. "/frame1" .. video_data[video].format
    currentFrame = 1
    framerate = video_data[video].fps
    endFrame = video_data[video].frames
  --  frames[video] =   frames[video]  or {}
    --[[
    for i=1, endFrame do
        if not frames[selectedVideo][i] then 
        frames[selectedVideo][i] = LoadSprite("image/" .. selectedVideo .. "/frame" .. tostring(i) .. ".png")
        DebugPrint("Loading... (" .. tostring(i) .. "/" .. tostring(endFrame) .. ")")
        end
    end]]
end
oldFrame = 1
updateFrame = 0
updateamount = 0
currentFrameString = "image/" .. "badapple" .. "/frame1" .. video_data["badapple"].format
function playVideo()
    if not selectedVideo then return end
    if not currentAudio then return end
    if not currentFrameSprite then return end

    local transform = GetShapeWorldTransform(monitor)
    PlayLoop(currentAudio, transform.pos,0.5)

    currentFrameString = "image/" .. selectedVideo .. "/frame" .. tostring(currentFrame) .. video_data[selectedVideo].format
    --currentFrameSprite = LoadSprite(currentFrameString) 
    local right = TransformToParentVec(transform,Vec(1,0,0))
    local up = 	TransformToParentVec(transform, Vec(0,1,0))
    local forward = TransformToParentVec(transform, Vec(0,0,1))
    --local pos = VecAdd( transform.pos, VecAdd( VecScale(forward, -0.105), VecAdd(VecScale(right,  1), VecScale(up,  0.5) )) )

    local pos_prerender =  VecAdd( transform.pos, VecAdd( VecScale(forward, 0.105), VecAdd(VecScale(right,  1), VecScale(up,  0.5) )) )

    for i=1, 5 do -- Need to do this so it doesnt flicker
        local currentFrameSpritePreRender = LoadSprite("image/" .. selectedVideo .. "/frame" .. tostring(currentFrame+i) .. video_data[selectedVideo].format)
        DrawSprite(currentFrameSpritePreRender,Transform(pos_prerender, transform.rot),2,1, 1,1,1,1, true, false)
    end
   -- DrawSprite(currentFrameSprite,Transform(pos, transform.rot),2,1, 1,1,1,1, true, false)
end


function updateFrame()

    updateamount = (GetTime() > nextFrame) and 1 or 0
    currentFrame = currentFrame + ( updateamount )


    if currentFrame > endFrame then
        currentFrame = 1
    end


  
 -- frames[selectedVideo][currentFrame]  --LoadSprite(new_frame)
    currentFrameString = "image/" .. selectedVideo .. "/frame" .. tostring(currentFrame) .. video_data[selectedVideo].format
  

    currentFrameSprite = LoadSprite(currentFrameString)     
end

function newFrame()
    if not selectedVideo then return end
    if not currentAudio then return end
  
  
    time = GetTime()

    if  (time > nextFrame) then
        nextFrame = time + (1 / framerate)
     
    end
end

function tick()
    updateFrame()
    playVideo()
    newFrame()
    DebugWatch('frame',tostring(currentFrame))
    DebugWatch('frame string', tostring(currentFrameString))
    DebugWatch('time', tostring(time))
    DebugWatch('next frame', tostring(nextFrame))
    DebugWatch( "update", tostring( updateamount))
end

function update()
   
end