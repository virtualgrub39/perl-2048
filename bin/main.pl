#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";   

use Raylib;

my ($WINDOW_W, $WINDOW_H) = (500, 500);

my $color_bg = Raylib::Color(56, 63, 81);
my $color_fg = Raylib::Color(221, 219, 241);

my @board = ();
my ($board_w, $board_h) = (4, 4);

sub game_init {
    for (my $i = 0; $i < $board_h; $i++)
    {
        for (my $j = 0; $j < $board_w; $j++)
        {
            $board[$i][$j] = 0;
        }
    }

    $board[$board_w-1][$board_h-1] = 2;
    $board[$board_w-2][$board_h-1] = 2;
}

sub game_display {
    Raylib::clear_background($color_bg);
}

sub game_update {

}

Raylib::init_window($WINDOW_W, $WINDOW_H, "nyaa <3");

game_init();

until (Raylib::window_should_close()) {
    game_update();

    Raylib::begin_drawing();
    game_display();
    Raylib::end_drawing();
}

Raylib::close_window();
