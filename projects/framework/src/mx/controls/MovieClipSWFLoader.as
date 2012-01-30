////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2010 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.controls
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;

import mx.core.MovieClipLoaderAsset;
import mx.managers.ISystemManager;

/**
 *  The MovieClipSWFLoader control extends SWFLoader to provide convenience
 *  methods for manipulating a SWF which has a MovieClip as its root content,
 *  provided that the MovieClip is not a Flex application.
 * 
 *  Note that for all other SWF content types, this class will return null
 *  for the movieClip getter and will result in a no-op for function calls.
 *  
 */
public class MovieClipSWFLoader extends SWFLoader
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    public function MovieClipSWFLoader()
    {
        super();
        
        addEventListener(Event.COMPLETE, handleComplete);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     *  When the content of the SWF is a MovieClip, if autoStop is true then
     *  the MovieClip is stopped immediately after loading.
     * 
     *  @default true
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    public var autoStop:Boolean = true;
    
    
    /**
     *  Handle to the underlying MovieClip of the loaded SWF. If the SWF is not
     *  rooted in a MovieClip, this property will be null.
     * 
     *  @return MovieClip if the content is of type MovieClip; otherwise,
     *          return null
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    public function get movieClip():MovieClip
    {
        var content:DisplayObject = this.content;
        
        if (content is MovieClipLoaderAsset)
        {
            // Get child MovieClip from Loader
            if (DisplayObjectContainer(content).numChildren > 0)
                content = 
                    Loader(DisplayObjectContainer(content).getChildAt(0)).content;
        }
        
        if (content is MovieClip && !(content is ISystemManager))
            return MovieClip(content);
        
        return null;
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Begins playing the SWF content. If the content is not a MovieClip,
     *  this results in a no-op. 
     * 
     *  @see flash.display.MovieClip#play
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function play():void
    {
        var movieClip:MovieClip = this.movieClip;
        if (movieClip)
            movieClip.play();
    }
    
    /**
     *  Stops the SWF content. If the content is not a MovieClip,
     *  this results in a no-op.
     * 
     *  @see flash.display.MovieClip#stop
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    public function stop():void
    {
        var movieClip:MovieClip = this.movieClip;
        if (movieClip)
            movieClip.stop(); // stop at current frame
    }
    
    /**
     *  Starts playing the SWF file at the specified frame. If the
     *  content is not a MovieClip, this results in a no-op.
     * 
     *  @see flash.display.MovieClip#gotoAndPlay
     * 
     *  @param frame
     *  @param scene
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    
    public function gotoAndPlay(frame:Object, scene:String = null):void
    {
        var movieClip:MovieClip = this.movieClip;
        if (movieClip)
            movieClip.gotoAndPlay(frame, scene);
    }
    
    /**
     *  Resets the playhead to the first frame and stops the MovieClip.
     *  If the content is not a MovieClip, this results in a no-op.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    public function gotoFirstFrameAndStop():void
    {
        var movieClip:MovieClip = this.movieClip;
        if (movieClip)
            movieClip.gotoAndStop(0, movieClip.scenes ? movieClip.scenes[0].name : null); // go to first frame and stop
    }
    
    /**
     *  Stops playing the SWF and resets the playhead to the specified frame.
     *  If the content is not a MovieClip, this results in a no-op.
     * 
     *  @see flash.display.MovieClip#gotoAndStop
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    public function gotoAndStop(frame:Object, scene:String = null):void
    {
        var movieClip:MovieClip = this.movieClip;
        if (movieClip)
            movieClip.gotoAndStop(frame, scene);
    }
    
    /**
     *  Go to the next frame. No-op if content is not a MovieClip.
     * 
     *  @see flash.display.MovieClip#nextFrame 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    public function nextFrame():void
    {
        var movieClip:MovieClip = this.movieClip;
        if (movieClip)
            movieClip.nextFrame();
    }
    
    /**
     *  Go to the next scene. No-op if content is not a MovieClip.
     * 
     *  @see flash.display.MovieClip#nextScene 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    public function nextScene():void
    {
        var movieClip:MovieClip = this.movieClip;
        if (movieClip)
            movieClip.nextScene();
    }
    
    /**
     *  Go to the previous frame. No-op if content is not a MovieClip.
     * 
     *  @see flash.display.MovieClip#prevFrame 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    public function prevFrame():void
    {
        var movieClip:MovieClip = this.movieClip;
        if (movieClip)
            movieClip.prevFrame();
    }
    
    /**
     *  Go to the previous scene. No-op if content is not a MovieClip.
     * 
     *  @see flash.display.MovieClip#prevScene 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */        
    public function prevScene():void
    {
        var movieClip:MovieClip = this.movieClip;
        if (movieClip)
            movieClip.prevScene();
    }
    
    //-----------------------------------
    //  internal functions
    //-----------------------------------
    

    /**
     *  On completion of SWF loading, explicitly stop the SWF
     *  (i.e. prevent auto-play) if autoStop is true.
     * 
     *  @private
     *  
     *  @param event
     * 
     */        
    private function handleComplete(event:Event):void
    {
        if (autoStop)
            stop();
    }
    
    
}
}