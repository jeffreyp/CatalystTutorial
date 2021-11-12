package HelloCatalyst::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

HelloCatalyst::View::HTML - TT View for HelloCatalyst

=head1 DESCRIPTION

TT View for HelloCatalyst.

=head1 SEE ALSO

L<HelloCatalyst>

=head1 AUTHOR

Jeffrey Pratt

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
