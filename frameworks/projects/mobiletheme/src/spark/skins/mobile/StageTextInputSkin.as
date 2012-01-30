////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2011 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package spark.skins.mobile
{
import spark.components.TextInput;
import spark.components.supportClasses.StyleableTextField;
import spark.skins.mobile.supportClasses.StageTextSkinBase;

/**
 *  ActionScript-based skin for TextInput controls in mobile applications. 
 * 
 *  @see spark.components.TextInput
 * 
 *  @langversion 3.0
 *  @playerversion AIR 3.0 
 *  @productversion Flex 4.5.2
 */
public class StageTextInputSkin extends StageTextSkinBase
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion AIR 3.0
     *  @productversion Flex 4.5.2
     */
    public function StageTextInputSkin()
    {
        super();
        multiline = false;
    }    

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /** 
     *  @copy spark.skins.spark.ApplicationSkin#hostComponent
     */
    public var hostComponent:TextInput;  // SkinnableComponent will populate
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function layoutContents(unscaledWidth:Number, 
                                               unscaledHeight:Number):void
    {
        // base class handles border position & size
        super.layoutContents(unscaledWidth, unscaledHeight);
        
        // position & size the text
        var paddingLeft:Number = getStyle("paddingLeft");
        var paddingRight:Number = getStyle("paddingRight");
        var paddingTop:Number = getStyle("paddingTop");
        var paddingBottom:Number = getStyle("paddingBottom");
        
        var unscaledTextWidth:Number = unscaledWidth - paddingLeft - paddingRight;
        var unscaledTextHeight:Number = unscaledHeight - paddingTop - paddingBottom;
        
        // default vertical positioning is centered
        var textHeight:Number = getElementPreferredHeight(textDisplay);
        var textY:Number = Math.round(0.5 * (unscaledTextHeight - textHeight)) + paddingTop;
        
        if (textDisplay)
        {
            textDisplay.commitStyles();
            setElementSize(textDisplay, unscaledTextWidth, unscaledTextHeight);
            setElementPosition(textDisplay, paddingLeft, textY);
        }
        
        if (promptDisplay)
        {
            if (promptDisplay is StyleableTextField)
                StyleableTextField(promptDisplay).commitStyles();
            
            var promptHeight:Number = getElementPreferredHeight(promptDisplay);
            var promptY:Number = Math.round(0.5 * (unscaledTextHeight - promptHeight)) + paddingTop;
                
            setElementSize(promptDisplay, unscaledTextWidth, promptHeight);
            setElementPosition(promptDisplay, paddingLeft, promptY);
        }
    }
    
    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();
        measureTextComponent(hostComponent);
    }
}
}