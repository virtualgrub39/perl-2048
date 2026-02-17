package Raylib;
use strict;
use warnings;

use FFI::Platypus;
use Exporter 'import';
use File::Basename qw(dirname);
use File::Spec;

our @EXPORT_OK = qw(init_window window_should_close close_window begin_drawing end_drawing);

my $ffi = FFI::Platypus->new( api => 1 );

my $dir = dirname(__FILE__);
$ffi->lib( File::Spec->catfile($dir, 'libraylib.so') );

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


1;
