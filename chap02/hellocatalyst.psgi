use strict;
use warnings;

use HelloCatalyst;

my $app = HelloCatalyst->apply_default_middlewares(HelloCatalyst->psgi_app);
$app;

