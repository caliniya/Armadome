shader_type canvas_item;

// 控制网格参数
uniform vec2 cell_size = vec2(100.0, 100.0);
uniform vec4 grid_color : hint_color = vec4(1.0, 1.0, 1.0, 0.2);
uniform float line_width = 1.0;
uniform vec2 camera_offset;

void fragment() {
    // 计算世界坐标（考虑摄像机偏移）
    vec2 world_pos = UV * VIEWPORT_SIZE + camera_offset;
    
    // 计算网格坐标
    vec2 grid_pos = mod(world_pos, cell_size);
    
    // 计算线条范围
    float x_line = step(cell_size.x - line_width, grid_pos.x);
    float y_line = step(cell_size.y - line_width, grid_pos.y);
    
    // 混合颜色
    COLOR = mix(COLOR, grid_color, max(x_line, y_line));
}