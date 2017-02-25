package views.forms {
import starling.display.Quad;
import starling.display.Sprite;
import starling.display.MeshBatch;

public class FormGroup extends Sprite {
    private var w:int;
    private var labelW:int;
    private var h:int;
    private var bg:MeshBatch = new MeshBatch();

    public function FormGroup(_w:int, _labelW:int, _h:int) {
        super();
        w = _w;
        labelW = _labelW;
        h = _h;
        bg.touchable = false;
        bg.addMesh(new Quad(10, 1, 0x3C3C3C));
        var lineLeft:Quad = new Quad(1, h - 1, 0x3C3C3C);
        var lineRight:Quad = new Quad(1, h - 1, 0x3C3C3C);
        var lineBot:Quad = new Quad(w, 1, 0x3C3C3C);
        var lineTop:Quad = new Quad(w - 10 - labelW, 1, 0x3C3C3C);
        lineTop.x = 10 + labelW;
        lineRight.x = w - 1;
        lineBot.y = h - 1;
        bg.addMesh(lineTop);
        bg.addMesh(lineRight);
        bg.addMesh(lineBot);
        bg.addMesh(lineLeft);
        addChild(bg);

    }
}
}