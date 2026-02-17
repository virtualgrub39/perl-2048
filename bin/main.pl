#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";   

use Raylib;

Raylib::init_window(800, 600, "nyaa <3");

until (Raylib::window_should_close()) {
    Raylib::begin_drawing();

    Raylib::end_drawing();
}

Raylib::close_window();
