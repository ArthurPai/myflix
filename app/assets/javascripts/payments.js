/**
 * Created by Arthur on 2014/7/18.
 */

$(function() {
    $('#new_user').submit(function(event) {
        var $form = $(this);
        $form.find("input[type=submit]").prop('disabled', true);
        Stripe.card.createToken($form, stripeResponseHandler);
        return false;
    });

    function stripeResponseHandler(status, response) {
        var $form = $('#new_user');

        if (response.error) {
            $form.find('.payment-errors').text(response.error.message).closest('.alert').show();
            $form.find("input[type=submit]").prop('disabled', false);
        } else {
            var token = response.id;
            $form.append($('<input type="hidden" name="stripeToken" />').val(token));
            $form.get(0).submit();
        }
    }
});