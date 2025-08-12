package common.ui.embed
{
   public class UIAssets
   {

      [Embed(source="UIAssets_UI_CONFIG.json", mimeType="application/octet-stream")]
      public static const UI_CONFIG:Class;

      [Embed(source="UIAssets_UI_SLICE_CONFIG.json", mimeType="application/octet-stream")]
      public static const UI_SLICE_CONFIG:Class;

      [Embed(source="UIAssets_UI.png")]
      public static var UI:Class;
   }
}
