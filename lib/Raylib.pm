package Raylib;
use strict;
use warnings;

use FFI::Platypus;
use Exporter 'import';
use File::Basename qw(dirname);
use File::Spec;

our @EXPORT_OK = qw(
    init_window window_should_close close_window begin_drawing end_drawing
    Color Vector2 clear_background draw_rectangle draw_text measure_text
);

use FFI::Platypus 2.00;  
my $ffi = FFI::Platypus->new( api => 2 );
$ffi->lib( File::Spec->catfile(dirname(__FILE__), 'libraylib.so') );

{
    package Raylib::Color;
    use strict;
    use warnings;
    use FFI::Platypus::Record;
    record_layout_1(
        'uint8' => 'r',
        'uint8' => 'g',
        'uint8' => 'b',
        'uint8' => 'a',
    );
    1;
}

{
    package Raylib::Vector2;
    use strict;
    use warnings;
    use FFI::Platypus::Record;
    record_layout_1(
        'float' => 'x',
        'float' => 'y',
    );
    1;
}

$ffi->type( 'record(Raylib::Color)'   => 'ray_color' );
$ffi->type( 'record(Raylib::Vector2)' => 'ray_vec2' );

sub Color {
    my ($r, $g, $b, $a) = @_;
    $a = 255 unless defined $a;
    return Raylib::Color->new( r => $r, g => $g, b => $b, a => $a );
}

sub Vector2 {
    my ($x, $y) = @_;
    return Raylib::Vector2->new( x => $x, y => $y );
}

$ffi->attach( 'InitWindow' => ['int', 'int', 'string'] => 'void' );
sub init_window {
    my ($width, $height, $title) = @_;
    InitWindow($width, $height, $title);   
}

$ffi->attach( 'WindowShouldClose' => [] => 'int'  );
sub window_should_close {
    return WindowShouldClose();
}

$ffi->attach( 'CloseWindow' => [] => 'void' );
sub close_window {
    CloseWindow();   
}

$ffi->attach( 'BeginDrawing' => [] => 'void' );
sub begin_drawing {
    BeginDrawing();   
}

$ffi->attach( 'EndDrawing' => [] => 'void' );
sub end_drawing {
    EndDrawing();   
}

$ffi->attach( 'ClearBackground' => ['ray_color'] => 'void' );
sub clear_background {
    my ($color) = @_;
    ClearBackground($color); 
}

$ffi->attach( 'DrawRectangle' => ['int', 'int', 'int', 'int', 'ray_color'] => 'void' );
sub draw_rectangle {
    my ($pos_x, $pos_y, $width, $height, $color) = @_;
    DrawRectangle($pos_x, $pos_y, $width, $height, $color); 
}

$ffi->attach( 'DrawText' => ['string', 'int', 'int', 'int', 'ray_color'] => 'void' );
sub draw_text {
    my ($string, $pos_x, $pos_y, $font_size, $color) = @_;
    DrawText($string, $pos_x, $pos_y, $font_size, $color); 
}

$ffi->attach( 'MeasureText' => ['string', 'int'] => 'int' );
sub measure_text {
    my ($string, $font_size) = @_;
    return MeasureText($string, $font_size); 
}

1;
