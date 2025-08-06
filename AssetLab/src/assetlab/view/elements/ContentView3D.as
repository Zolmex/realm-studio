package assetlab.view.elements {
import assetlab.view.MainView;
import assetlab.view.WorkspaceView;

import away3d.containers.View3D;
import away3d.loaders.Loader3D;
import away3d.loaders.parsers.OBJParser;
import away3d.loaders.parsers.Parsers;

import common.Global;

import flash.display.BlendMode;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.utils.ByteArray;

public class ContentView3D extends Sprite {

    private var workspace:WorkspaceView;
    private var viewMask:Shape;
    private var view3D:View3D;
    private var loader:Loader3D;
    private var lastMouseX:Number = 0;
    private var lastMouseY:Number = 0;

    public function ContentView3D(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.viewMask = new Shape();
        this.viewMask.graphics.beginFill(0);
        this.viewMask.graphics.drawRect(0, 0, workspace.contentWidth - FileBrowser.WIDTH - 1, workspace.contentHeight);
        this.viewMask.graphics.endFill();
        this.viewMask.blendMode = BlendMode.ERASE;

        this.view3D = new View3D();
        this.view3D.camera.z = -50;
        this.view3D.camera.y = 50;
        this.view3D.camera.lookAt(new Vector3D()); // Make camera look at 3d space origin
        this.view3D.width = this.viewMask.width;
        this.view3D.height = this.viewMask.height;
        addChild(this.view3D);

        Parsers.enableAllBundled();
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
    }

    private function onPlaneMouseDown(e:MouseEvent):void {
        addEventListener(MouseEvent.MOUSE_MOVE, this.onPlaneMouseMove);
    }

    private function onPlaneMouseUp(e:MouseEvent):void {
        this.lastMouseX = 0;
        this.lastMouseY = 0;
        removeEventListener(MouseEvent.MOUSE_MOVE, this.onPlaneMouseMove);
    }

    private function onPlaneMouseMove(e:MouseEvent):void {
        if (this.loader == null || !this.view3D.scene.contains(this.loader)){
            return;
        }

        if (this.lastMouseX == 0){
            this.lastMouseX = e.stageX;
        }
        if (this.lastMouseY == 0){
            this.lastMouseY = e.stageY;
        }

        var deltaH:Number = (e.stageX - this.lastMouseX) * -1; // Inverted so it makes sense from  a user perspective
        var deltaV:Number = (e.stageY - this.lastMouseY) * -1;

        this.lastMouseX = e.stageX;
        this.lastMouseY = e.stageY;
        this.loader.rotationY += deltaH;
        this.loader.rotationX += deltaV;
    }

    private function onEnterFrame(e:Event):void {
        this.view3D.render();
    }

    private function onMouseWheel(e:MouseEvent):void {
        this.view3D.camera.z += e.delta;
        this.view3D.camera.y -= e.delta;
    }

    private function onAddedToStage(e:Event):void { // Apply mask so that view3D is visible (drawn at the Stage3D layer)
        addEventListener(MouseEvent.MOUSE_DOWN, this.onPlaneMouseDown);
        addEventListener(MouseEvent.MOUSE_UP, this.onPlaneMouseUp);
        addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);

        this.updateMaskPosition();
        MainView.Instance.parent.addChild(this.viewMask);
    }

    private function updateMaskPosition():void {
        var sPoint:Point = parent.localToGlobal(new Point(this.x, this.y));
        this.viewMask.x = sPoint.x;
        this.viewMask.y = sPoint.y;
    }

    public function displayModel3D(model3DBytes:ByteArray):void {
        if (this.view3D.scene.contains(this.loader)){
            this.view3D.scene.removeChild(this.loader);
            this.loader.dispose();
        }

        this.loader = new Loader3D();
        this.loader.loadData(model3DBytes, null, null, new OBJParser(20));
        this.view3D.scene.addChild(this.loader);
    }

    public function resize():void {
        this.updateMaskPosition();
        this.viewMask.graphics.clear();
        this.viewMask.graphics.beginFill(0);
        this.viewMask.graphics.drawRect(0, 0, this.workspace.contentWidth - FileBrowser.WIDTH - 1, this.workspace.contentHeight);
        this.viewMask.graphics.endFill();
        this.view3D.width = this.viewMask.width;
        this.view3D.height = this.viewMask.height;
    }

    public override function set visible(val:Boolean):void {
        super.visible = val;
        this.view3D.visible = val;
        this.viewMask.visible = val;
    }
}
}
