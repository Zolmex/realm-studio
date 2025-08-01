package assetlab.view.elements {
import assetlab.view.MainView;

import away3d.containers.View3D;
import away3d.entities.Mesh;
import away3d.materials.TextureMaterial;
import away3d.primitives.PlaneGeometry;
import away3d.utils.Cast;

import flash.display.BlendMode;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Vector3D;
import flash.utils.ByteArray;

public class ContentView extends Sprite { // Visualizer for .png images and 3D models

    [Embed(source="../embed/floor_diffuse.jpg")]
    public static var FloorDiffuse:Class;

    public static const WIDTH:int = 527;
    public static const HEIGHT:int = 492;

    private var viewMask:Shape;
    private var view3D:View3D;

    // Test
    private var plane:Mesh;

    public function ContentView() {
        this.viewMask = new Shape();
        this.viewMask.graphics.beginFill(0);
        this.viewMask.graphics.drawRect(0, 0, WIDTH, HEIGHT);
        this.viewMask.graphics.endFill();
        this.viewMask.blendMode = BlendMode.ERASE;

        this.view3D = new View3D();
        this.view3D.camera.z = -600;
        this.view3D.camera.y = 500;
        this.view3D.camera.lookAt(new Vector3D());
        addChild(this.view3D);

        this.plane = new Mesh(new PlaneGeometry(700, 700), new TextureMaterial(Cast.bitmapTexture(FloorDiffuse)));
        this.view3D.scene.addChild(this.plane);

        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(e:Event):void {
        this.plane.rotationY += 1;
        this.view3D.render();
    }

    private function onAddedToStage(e:Event):void { // Apply mask so that view3D is visible (drawn at the Stage3D layer)
        var sPoint:Point = parent.localToGlobal(new Point(this.x, this.y));
        this.viewMask.x = sPoint.x;
        this.viewMask.y = sPoint.y;
        MainView.Instance.parent.addChild(this.viewMask);
    }

    public function displayModel3D(model3DBytes:ByteArray):void {

    }
}
}
