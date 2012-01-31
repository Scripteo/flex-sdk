////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2008 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package spark.components
{

import mx.collections.IList;
import mx.core.IFactory;
import mx.core.IVisualElement; 
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.managers.IFocusManagerContainer;
import mx.utils.BitFlagUtil;

import spark.components.supportClasses.ItemRenderer;
import spark.components.supportClasses.SkinnableContainerBase;
import spark.core.IViewport;
import spark.events.RendererExistenceEvent;
import spark.layouts.supportClasses.LayoutBase;

/**
 *  Dispatched when a renderer is added to the dataGroup.
 * <code>event.renderer</code> is the renderer that was added.
 *
 *  @eventType spark.events.RendererExistenceEvent.RENDERER_ADD
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event(name="rendererAdd", type="spark.events.RendererExistenceEvent")]

/**
 *  Dispatched when a renderer is removed from the dataGroup.
 * <code>event.renderer</code> is the renderer that was removed.
 *
 *  @eventType spark.events.RendererExistenceEvent.RENDERER_REMOVE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event(name="rendererRemove", type="spark.events.RendererExistenceEvent")]

include "../styles/metadata/BasicInheritingTextStyles.as"

/**
 *  Color of focus ring when the component is in focus.
 *
 *  @default 0x70B2EE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */ 
[Style(name="focusColor", type="uint", format="Color", inherit="yes", theme="spark")]

[DefaultProperty("dataProvider")]

[IconFile("SkinnableDataContainer.png")]

/**
 *  The SkinnableDataContainer class is the base container class for
 *  data items.  The SkinnableDataContainer class converts data 
 *  items to visual elements for display.
 *  While this container can hold visual elements, it is often used only 
 *  to hold data items as children.
 *
 *  <p>The SkinnableDataContainer class takes as children data items 
 *  or visual elements that implement the IVisualElement interface
 *  and are Display Objects.
 *  Data items can be simple data items such String and Number objects, 
 *  and more complicated data items such as Object and XMLNode objects. 
 *  While these containers can hold visual elements, 
 *  they are often used only to hold data items as children.</p>
 *
 *  <p>An item renderer defines the visual representation of the 
 *  data item in the container. 
 *  The item renderer converts the data item into a format that can 
 *  be displayed by the container. 
 *  You must pass an item renderer to a SkinnableDataContainer to 
 *  render data items appropriately.</p>
 *
 *  <p>If you want a container of data items and don't need a skin, then 
 *  it is recommended to use a DataGroup (which cannot be skinned) to 
 *  improve performance and application size.</p>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;SkinnableDataContainer&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;SkinnableDataContainer
 *    <strong>Properties</strong>
 *    autoLayout="true"
 *    clipAndEnableScrolling="false"
 *    dataProvider="null"
 *    horizontalScrollPosition="null"
 *    itemRenderer="null"
 *    itemRendererFunction="null"
 *    layout="VerticalLayout"
 *    typicalItem="null"
 *    verticalScrollPosition="null"
 *  
 *    <strong>Events</strong>
 *    rendererAdd="<i>No default</i>"
 *    rendererRemove="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see SkinnableContainer
 *  @see DataGroup
 *  @see spark.skins.spark.SkinnableDataContainerSkin
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class SkinnableDataContainer extends SkinnableContainerBase implements IViewport, IItemRendererOwner
{
    include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private static const CLIP_AND_ENABLE_SCROLLING_PROPERTY_FLAG:uint = 1 << 0;
    
    /**
     *  @private
     */
    private static const LAYOUT_PROPERTY_FLAG:uint = 1 << 1;
    
    /**
     *  @private
     */
    private static const HORIZONTAL_SCROLL_POSITION_PROPERTY_FLAG:uint = 1 << 2;
    
    /**
     *  @private
     */
    private static const VERTICAL_SCROLL_POSITION_PROPERTY_FLAG:uint = 1 << 3;
    
    /**
     *  @private
     */
    private static const AUTO_LAYOUT_PROPERTY_FLAG:uint = 1 << 4;
    
    /**
     *  @private
     */
    private static const DATA_PROVIDER_PROPERTY_FLAG:uint = 1 << 5;
    
    /**
     *  @private
     */
    private static const ITEM_RENDERER_PROPERTY_FLAG:uint = 1 << 6;
    
    /**
     *  @private
     */
    private static const ITEM_RENDERER_FUNCTION_PROPERTY_FLAG:uint = 1 << 7;
    
    /**
     *  @private
     */
    private static const TYPICAL_ITEM_PROPERTY_FLAG:uint = 1 << 8;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function SkinnableDataContainer()
    {
        super();
        
        tabChildren = true;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------
    
    [SkinPart(required="false")]
    
    /**
     *  A required skin part that defines the DataGroup in the skin class 
     *  where data items get pushed into, rendered, and laid out.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var dataGroup:DataGroup;
    
    /**
     *  @private
     *  Several properties are proxied to dataGroup.  However, when dataGroup
     *  is not around, we need to store values set on SkinnableDataContainer.  This object 
     *  stores those values.  If dataGroup is around, the values are stored 
     *  on the dataGroup directly.  However, we need to know what values 
     *  have been set by the developer on the SkinnableDataContainer (versus set on 
     *  the dataGroup or defaults of the dataGroup) as those are values 
     *  we want to carry around if the dataGroup changes (via a new skin). 
     *  In order to store this info effeciently, dataGroupProperties becomes 
     *  a uint to store a series of BitFlags.  These bits represent whether a 
     *  property has been explicitly set on this SkinnableDataContainer.  When the 
     *  dataGroup is not around, dataGroupProperties is a typeless 
     *  object to store these proxied properties.  When dataGroup is around,
     *  dataGroupProperties stores booleans as to whether these properties 
     *  have been explicitly set or not.
     */
    private var dataGroupProperties:Object = {};
    
    //--------------------------------------------------------------------------
    //
    //  Properties 
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  Properties proxied to dataGroup
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  autoLayout
    //----------------------------------

    [Inspectable(defaultValue="true")]

    /**
     *  @copy spark.components.supportClasses.GroupBase#autoLayout
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get autoLayout():Boolean
    {
        if (dataGroup)
            return dataGroup.autoLayout;
        else
        {
            // want the default to be true
            var v:* = dataGroupProperties.autoLayout;
            return (v === undefined) ? true : v;
        }
    }

    /**
     *  @private
     */
    public function set autoLayout(value:Boolean):void
    {
        if (dataGroup)
        {
            dataGroup.autoLayout = value;
            dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                                                     AUTO_LAYOUT_PROPERTY_FLAG, true);
        }
        else
            dataGroupProperties.autoLayout = value;
    }
    
    //----------------------------------
    //  clipAndEnableScrolling
    //----------------------------------
    
    /**
     *  @inheritDoc
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get clipAndEnableScrolling():Boolean 
    {
        return (dataGroup) 
            ? dataGroup.clipAndEnableScrolling 
            : dataGroupProperties.clipAndEnableScrolling;
    }

    /**
     *  @private
     */
    public function set clipAndEnableScrolling(value:Boolean):void 
    {       
        if (dataGroup)
        {
            dataGroup.clipAndEnableScrolling = value;
            dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                                                     CLIP_AND_ENABLE_SCROLLING_PROPERTY_FLAG, true);
        }
        else
            dataGroupProperties.clipAndEnableScrolling = value;
    }
    
    //----------------------------------
    //  contentWidth
    //---------------------------------- 
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]    

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get contentWidth():Number 
    {
        return (dataGroup) ? dataGroup.contentWidth : 0;  
    }

    //----------------------------------
    //  contentHeight
    //---------------------------------- 
    
    [Bindable("propertyChange")]
    [Inspectable(category="General")]    

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get contentHeight():Number 
    {
        return (dataGroup) ? dataGroup.contentHeight : 0;
    }
    
    //----------------------------------
    //  content
    //----------------------------------    
    
    /**
     *  @copy spark.components.DataGroup#dataProvider
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    [Bindable]
    public function get dataProvider():IList
    {       
        return (dataGroup) 
            ? dataGroup.dataProvider 
            : dataGroupProperties.dataProvider;
    }
    
    public function set dataProvider(value:IList):void
    {
        if (dataGroup)
        {
            dataGroup.dataProvider = value;
            dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                                                     DATA_PROVIDER_PROPERTY_FLAG, true);
        }
        else
            dataGroupProperties.dataProvider = value;
    }
    
    //----------------------------------
    //  horizontalScrollPosition
    //----------------------------------
        
    [Bindable("propertyChange")]

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get horizontalScrollPosition():Number 
    {
        return (dataGroup) 
            ? dataGroup.horizontalScrollPosition 
            : dataGroupProperties.horizontalScrollPosition;
    }

    /**
     *  @private
     */
    public function set horizontalScrollPosition(value:Number):void 
    {
        if (dataGroup)
        {
            dataGroup.horizontalScrollPosition = value;
            dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                                                     HORIZONTAL_SCROLL_POSITION_PROPERTY_FLAG, true);
        }
        else
            dataGroupProperties.horizontalScrollPosition = value;
    }
    
    //----------------------------------
    //  itemRenderer
    //----------------------------------
    
    /**
     *  @copy spark.components.DataGroup#itemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get itemRenderer():IFactory
    {
        return (dataGroup) 
            ? dataGroup.itemRenderer 
            : dataGroupProperties.itemRenderer;
    }
    
    /**
     *  @private
     */
    public function set itemRenderer(value:IFactory):void
    {
        if (dataGroup)
        {
            dataGroup.itemRenderer = value;
            dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                                                     ITEM_RENDERER_PROPERTY_FLAG, true);
        }
        else
            dataGroupProperties.itemRenderer = value;
    }
    
    //----------------------------------
    //  itemRendererFunction
    //----------------------------------
    
    /**
     *  @copy spark.components.DataGroup#itemRendererFunction
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get itemRendererFunction():Function
    {
        return (dataGroup) 
            ? dataGroup.itemRendererFunction 
            : dataGroupProperties.itemRendererFunction;
    }
    
    /**
     *  @private
     */
    public function set itemRendererFunction(value:Function):void
    {
        if (dataGroup)
        {
            dataGroup.itemRendererFunction = value;
            dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                                                     ITEM_RENDERER_FUNCTION_PROPERTY_FLAG, true);
        }
        else
            dataGroupProperties.itemRendererFunction = value;
    }
    
    //----------------------------------
    //  layout
    //----------------------------------
    
    /**
     *  @copy spark.components.supportClasses.GroupBase#layout
     *
     *  @default VerticalLayout
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */     
    public function get layout():LayoutBase
    {
        return (dataGroup) 
            ? dataGroup.layout 
            : dataGroupProperties.layout;
    }

    /**
     *  @private
     */
    public function set layout(value:LayoutBase):void
    {
        if (dataGroup)
        {
            dataGroup.layout = value;
            dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                                                     LAYOUT_PROPERTY_FLAG, true);
        }
        else
            dataGroupProperties.layout = value;
    }
    
    //----------------------------------
    //  typicalItem
    //----------------------------------

    /**
     *  @copy spark.components.DataGroup#typicalItem
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get typicalItem():Object
    {
        return (dataGroup) 
            ? dataGroup.typicalItem 
            : dataGroupProperties.typicalItem;
    }

    /**
     *  @private
     */
    public function set typicalItem(value:Object):void
    {
        if (dataGroup)
        {
            dataGroup.typicalItem = value;
            dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                                                     TYPICAL_ITEM_PROPERTY_FLAG, true);
        }
        else
            dataGroupProperties.typicalItem = value;
    }
    
    //----------------------------------
    //  verticalScrollPosition
    //----------------------------------
    
    [Bindable("propertyChange")]
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get verticalScrollPosition():Number 
    {
        return (dataGroup) 
            ? dataGroup.verticalScrollPosition 
            : dataGroupProperties.verticalScrollPosition;
    }

    /**
     *  @private
     */
    public function set verticalScrollPosition(value:Number):void 
    {
        if (dataGroup)
        {
            dataGroup.verticalScrollPosition = value;
            dataGroupProperties = BitFlagUtil.update(dataGroupProperties as uint, 
                                                     VERTICAL_SCROLL_POSITION_PROPERTY_FLAG, true);
        }
        else
            dataGroupProperties.verticalScrollPosition = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods proxied to dataGroup
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  getHorizontal,VerticalScrollPositionDelta
    //----------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
    {
        return (dataGroup) ? 
            dataGroup.getHorizontalScrollPositionDelta(navigationUnit) : 0;     
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
    {
        return (dataGroup) ? 
            dataGroup.getVerticalScrollPositionDelta(navigationUnit) : 0;     
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Given a data item, return the toString() representation 
     *  of the data item for an item renderer to display. Null 
     *  data items return the empty string. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function itemToLabel(item:Object):String
    {
        if (item !== null)
            return item.toString();
        else return " ";
    }

    /**
     *  Updates the renderer for use/re-use. When a renderer is first 
     *  created, or when it is recycled because of virtualization, this 
     *  SkinnableDataContainer gets the chance to come in and set the 
     *  renderer's <code>label</code> property as well as the 
     *  <code>owner</code> property. This is how, from a renderer, one 
     *  can access the parent component "owning" the renderer. In cases 
     *  like Lists and SkinnableDataContainers, the owner property points
     *  to the List or SkinnableDataContainer even though the dataGroup
     *  part is actually parenting the renderers. 
     *  
     *  @param renderer The renderer being updated 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     * 
     */
    public function updateRenderer(renderer:IVisualElement):void
    {
        renderer.owner = this;
        
        if (renderer is IItemRenderer)
            IItemRenderer(renderer).label = itemToLabel(IItemRenderer(renderer).data);  
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function partAdded(partName:String, instance:Object):void
    {
        if (instance == dataGroup)
        {
            // copy proxied values from dataGroupProperties (if set) to dataGroup
            
            var newDataGroupProperties:uint = 0;
            
            if (dataGroupProperties.clipAndEnableScrolling !== undefined)
            {
                dataGroup.clipAndEnableScrolling = dataGroupProperties.clipAndEnableScrolling;
                newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                                                            CLIP_AND_ENABLE_SCROLLING_PROPERTY_FLAG, true);
            }
            
            if (dataGroupProperties.layout !== undefined)
            {
                dataGroup.layout = dataGroupProperties.layout;
                newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                                                            LAYOUT_PROPERTY_FLAG, true);;
            }
            
            if (dataGroupProperties.horizontalScrollPosition !== undefined)
            {
                dataGroup.horizontalScrollPosition = dataGroupProperties.horizontalScrollPosition;
                newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                                                            HORIZONTAL_SCROLL_POSITION_PROPERTY_FLAG, true);
            }
            
            if (dataGroupProperties.verticalScrollPosition !== undefined)
            {
                dataGroup.verticalScrollPosition = dataGroupProperties.verticalScrollPosition;
                newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                                                            VERTICAL_SCROLL_POSITION_PROPERTY_FLAG, true);
            }
            
            if (dataGroupProperties.autoLayout !== undefined)
            {
                dataGroup.autoLayout = dataGroupProperties.autoLayout;
                newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                                                            AUTO_LAYOUT_PROPERTY_FLAG, true);
            }
            
            if (dataGroupProperties.dataProvider !== undefined)
            {
                dataGroup.dataProvider = dataGroupProperties.dataProvider;
                newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                                                            DATA_PROVIDER_PROPERTY_FLAG, true);
            }
            
            if (dataGroupProperties.itemRenderer !== undefined)
            {
                dataGroup.itemRenderer = dataGroupProperties.itemRenderer;
                newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                                                            ITEM_RENDERER_PROPERTY_FLAG, true);
            }
            
            if (dataGroupProperties.itemRendererFunction !== undefined)
            {
                dataGroup.itemRendererFunction = dataGroupProperties.itemRendererFunction;
                newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                                                            ITEM_RENDERER_FUNCTION_PROPERTY_FLAG, true);
            }
            
            if (dataGroupProperties.typicalItem !== undefined)
            {
                dataGroup.typicalItem = dataGroupProperties.typicalItem;
                newDataGroupProperties = BitFlagUtil.update(newDataGroupProperties as uint, 
                                                            TYPICAL_ITEM_PROPERTY_FLAG, true);
            }
            
            dataGroupProperties = newDataGroupProperties;
            
            // SkinnableDataContainer needs to do work when a renderer is added, so 
            // listen for the 'rendererAdd' event and delegate to an event handler
            dataGroup.addEventListener(
                    RendererExistenceEvent.RENDERER_ADD, dataGroup_rendererAddChangeHandler);
            
            
            if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
            {
                // the only reason we have this listener is to re-dispatch events.  So only add it here
                // if someone's listening on us.
                dataGroup.addEventListener(
                    PropertyChangeEvent.PROPERTY_CHANGE, dataGroup_propertyChangeHandler);
            }
            
            if (hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
            {
                // the only reason we have this listener is to re-dispatch events.  So only add it here
                // if someone's listening on us.
                dataGroup.addEventListener(
                    RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
            }
        }
    }
    
    /**
     * @private
     */
    override protected function partRemoved(partName:String, instance:Object):void
    {
        if (instance == dataGroup)
        {
            dataGroup.removeEventListener(
                PropertyChangeEvent.PROPERTY_CHANGE, dataGroup_propertyChangeHandler);
            dataGroup.removeEventListener(
                RendererExistenceEvent.RENDERER_ADD, dataGroup_rendererAddChangeHandler);
            dataGroup.removeEventListener(
                RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
            
            // copy proxied values from dataGroup (if explicitly set) to dataGroupProperties
            
            var newDataGroupProperties:Object = {};
            
            if (BitFlagUtil.isSet(dataGroupProperties as uint, CLIP_AND_ENABLE_SCROLLING_PROPERTY_FLAG))
                newDataGroupProperties.clipAndEnableScrolling = dataGroup.clipAndEnableScrolling;
            
            if (BitFlagUtil.isSet(dataGroupProperties as uint, LAYOUT_PROPERTY_FLAG))
                newDataGroupProperties.layout = dataGroup.layout;
            
            if (BitFlagUtil.isSet(dataGroupProperties as uint, HORIZONTAL_SCROLL_POSITION_PROPERTY_FLAG))
                newDataGroupProperties.horizontalScrollPosition = dataGroup.horizontalScrollPosition;
            
            if (BitFlagUtil.isSet(dataGroupProperties as uint, VERTICAL_SCROLL_POSITION_PROPERTY_FLAG))
                newDataGroupProperties.verticalScrollPosition = dataGroup.verticalScrollPosition;
            
            if (BitFlagUtil.isSet(dataGroupProperties as uint, AUTO_LAYOUT_PROPERTY_FLAG))
                newDataGroupProperties.autoLayout = dataGroup.autoLayout;
            
            if (BitFlagUtil.isSet(dataGroupProperties as uint, DATA_PROVIDER_PROPERTY_FLAG))
                newDataGroupProperties.dataProvider = dataGroup.dataProvider;
            
            if (BitFlagUtil.isSet(dataGroupProperties as uint, ITEM_RENDERER_PROPERTY_FLAG))
                newDataGroupProperties.itemRenderer = dataGroup.itemRenderer;
            
            if (BitFlagUtil.isSet(dataGroupProperties as uint, ITEM_RENDERER_FUNCTION_PROPERTY_FLAG))
                newDataGroupProperties.itemRendererFunction = dataGroup.itemRendererFunction;
            
            if (BitFlagUtil.isSet(dataGroupProperties as uint, TYPICAL_ITEM_PROPERTY_FLAG))
                newDataGroupProperties.typicalItem = dataGroup.typicalItem;
                
            dataGroupProperties = newDataGroupProperties;
            
            dataGroup.dataProvider = null;
            dataGroup.layout = null;
        }
    }
    
    /**
     *  @private
     * 
     *  This method is overridden so we can figure out when someone starts listening
     *  for property change events.  If no one's listening for them, then we don't 
     *  listen for them on our dataGroup.
     */
    override public function addEventListener(
        type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false) : void
    {
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        
        // TODO (rfrishbe): this isn't ideal as we should deal with the useCapture, 
        // priority, and useWeakReference parameters.
        
        // if it's a different type of event or the dataGroup doesn't
        // exist, don't worry about it.  When the dataGroup, 
        // gets created up, we'll check to see whether we need to add this 
        // event listener to the dataGroup.
        if (type == PropertyChangeEvent.PROPERTY_CHANGE && dataGroup)
        {
            dataGroup.addEventListener(
                PropertyChangeEvent.PROPERTY_CHANGE, dataGroup_propertyChangeHandler);
        }
        
        if (type == RendererExistenceEvent.RENDERER_REMOVE && dataGroup)
        {
            dataGroup.addEventListener(
                RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
        }
    }
    
    /**
     *  @private
     * 
     *  This method is overridden so we can figure out when someone stops listening
     *  for property change events.  If no one's listening for them, then we don't 
     *  listen for them on our dataGroup.
     */
    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false) : void
    {
        super.removeEventListener(type, listener, useCapture);
        
        // if no one's listening to us for this event any more, let's 
        // remove our underlying event listener from the dataGroup.
        if (type == PropertyChangeEvent.PROPERTY_CHANGE && dataGroup)
        {
            if (!hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
            {
                dataGroup.removeEventListener(
                    PropertyChangeEvent.PROPERTY_CHANGE, dataGroup_propertyChangeHandler);
            }
        }
        
        if (type == RendererExistenceEvent.RENDERER_REMOVE && dataGroup)
        {
            if (!hasEventListener(RendererExistenceEvent.RENDERER_REMOVE))
            {
                dataGroup.removeEventListener(
                    RendererExistenceEvent.RENDERER_REMOVE, dispatchEvent);
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event Handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */
    private function dataGroup_propertyChangeHandler(event:PropertyChangeEvent):void
    {
        // Re-dispatch the event if it's one other people are binding too
        switch (event.property)
        {
            case 'contentWidth':
            case 'contentHeight':
            case 'horizontalScrollPosition':
            case 'verticalScrollPosition':
            {
                dispatchEvent(event);
            }
        }
    }
    
    /**
     * @private
     */
    private function dataGroup_rendererAddChangeHandler(event:RendererExistenceEvent):void
    {
        var renderer:IVisualElement = event.renderer;
        
        updateRenderer(renderer); 
        
        dispatchEvent(event);
    }
}

}
