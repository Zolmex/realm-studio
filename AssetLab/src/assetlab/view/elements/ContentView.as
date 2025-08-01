package assetlab.view.elements {
import assetlab.view.MainView;
import assetlab.view.WorkspaceView;

import away3d.containers.View3D;
import away3d.core.pick.PickingColliderType;
import away3d.core.pick.PickingType;
import away3d.entities.Mesh;
import away3d.events.MouseEvent3D;
import away3d.materials.TextureMaterial;
import away3d.primitives.PlaneGeometry;
import away3d.utils.Cast;

import common.Global;

import flash.display.BlendMode;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.utils.ByteArray;

public class ContentView extends Sprite { // Visualizer for .png images and 3D models

    [Embed(source="../embed/floor_diffuse.jpg")]
    public static var FloorDiffuse:Class;

    public static const WIDTH:int = 527;
    public static const HEIGHT:int = 492;

    private var workspace:WorkspaceView;
    private var viewMask:Shape;
    private var view3D:View3D;

    // Test
    private var plane:Mesh;
    private var lastMouseX:Number = 0;
    private var lastMouseY:Number = 0;

    public function ContentView(workspace:WorkspaceView) {
        this.workspace = workspace;

        this.viewMask = new Shape();
        this.viewMask.graphics.beginFill(0);
        this.viewMask.graphics.drawRect(0, 0, WIDTH, HEIGHT);
        this.viewMask.graphics.endFill();
        this.viewMask.blendMode = BlendMode.ERASE;

        this.view3D = new View3D();
        this.view3D.camera.z = -600;
        this.view3D.camera.y = 500;
        this.view3D.camera.lookAt(new Vector3D()); // Make camera look at 3d space origin
        this.view3D.width = this.viewMask.width;
        this.view3D.height = this.viewMask.height;
        addChild(this.view3D);

        this.plane = new Mesh(new PlaneGeometry(700, 700), new TextureMaterial(Cast.bitmapTexture(FloorDiffuse)));
        this.view3D.scene.addChild(this.plane);

        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
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
        this.plane.rotationY += deltaH;
        this.plane.rotationX += deltaV;
    }

    private function onEnterFrame(e:Event):void {
        this.view3D.render();
    }

    private function onAddedToStage(e:Event):void { // Apply mask so that view3D is visible (drawn at the Stage3D layer)
        addEventListener(MouseEvent.MOUSE_DOWN, this.onPlaneMouseDown);
        addEventListener(MouseEvent.MOUSE_UP, this.onPlaneMouseUp);

        this.updateMaskPosition();
        MainView.Instance.parent.addChild(this.viewMask);
    }

    private function updateMaskPosition():void {
        var sPoint:Point = parent.localToGlobal(new Point(this.x, this.y));
        this.viewMask.x = sPoint.x;
        this.viewMask.y = sPoint.y;
    }

    public function displayModel3D(model3DBytes:ByteArray):void {

    }

    public function resize():void {
        this.updateMaskPosition();
        this.viewMask.graphics.clear();
        this.viewMask.graphics.beginFill(0);
        this.viewMask.graphics.drawRect(0, 0, this.workspace.contentWidth - FileBrowser.WIDTH - 1, HEIGHT * Global.ScaleY);
        this.viewMask.graphics.endFill();
        this.view3D.width = this.viewMask.width;
        this.view3D.height = this.viewMask.height;
    }
}
}
