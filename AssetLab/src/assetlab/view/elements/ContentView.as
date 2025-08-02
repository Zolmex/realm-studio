package assetlab.view.elements {
import assetlab.view.MainView;
import assetlab.view.WorkspaceView;

import away3d.containers.ObjectContainer3D;

import away3d.containers.View3D;
import away3d.core.base.Geometry;
import away3d.core.base.Object3D;
import away3d.core.pick.PickingColliderType;
import away3d.core.pick.PickingType;
import away3d.entities.Mesh;
import away3d.events.AssetEvent;
import away3d.events.MouseEvent3D;
import away3d.events.ParserEvent;
import away3d.loaders.Loader3D;
import away3d.loaders.parsers.OBJParser;
import away3d.loaders.parsers.Parsers;
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

    public static const WIDTH:int = 527;
    public static const HEIGHT:int = 492;

    protected var workspace:WorkspaceView;

    public function ContentView(workspace:WorkspaceView) {
        this.workspace = workspace;
    }

    public virtual function resize():void {
    }
}
}
