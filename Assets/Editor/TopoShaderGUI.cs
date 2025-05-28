using UnityEngine;
using UnityEditor;

public class TopoShaderGUI : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        // Find properties by name
        MaterialProperty minY = FindProperty("_MinY", properties);
        MaterialProperty maxY = FindProperty("_MaxY", properties);
        MaterialProperty rampTex = FindProperty("_RampTex", properties);
        MaterialProperty bandCnt = FindProperty("_BandCnt", properties);

        // These are properties that can just use built-in UIs
        materialEditor.ShaderProperty(minY, minY.displayName);
        materialEditor.ShaderProperty(maxY, maxY.displayName);
        materialEditor.ShaderProperty(rampTex, rampTex.displayName);

        // This is the int slider
        int bandValue = Mathf.RoundToInt(bandCnt.floatValue);
        int newBandValue = EditorGUILayout.IntSlider(bandCnt.displayName, bandValue, 1, 22);
        if (newBandValue != bandValue)
        {
            bandCnt.floatValue = newBandValue;
        }
    }
}
