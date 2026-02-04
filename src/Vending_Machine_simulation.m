function vending_machine_simulation()
    global totalPrice selectedProducts;
    totalPrice = 0; % Inital total price
    selectedProducts = {}; % Initial selected products

    % Vending machine start screen
    machine_fig = figure('Name', 'Vending Machine', 'Position', [100, 100, 1000, 800], ...
                         'Color', [1, 1, 1]);

    % Vending machine image
    axes('Position', [0.1, 0.2, 0.8, 0.6]);
    try
        imshow('VendingMachine.png'); % Main vending machine image
    catch
        warning('Vending machine image could not be loaded!');
        text(0.5, 0.5, 'Vending Machine Image Missing', 'HorizontalAlignment', 'center', ...
             'FontSize', 16, 'FontWeight', 'bold', 'Color', [1, 0, 0]);
    end
    axis off;

% Welcome button
uicontrol(machine_fig, 'Style', 'pushbutton', ...
          'Position', [450, 50, 100, 40], ...
          'String', 'WELCOME', ...
          'FontSize', 12, ...
          'Callback', @go_to_selection_screen);

end

function go_to_selection_screen(~, ~)
    global totalPrice selectedProducts;

    % Product selection screen
    selection_fig = figure('Name', 'Product Selection', 'Position', [100, 100, 1000, 800], ...
                           'Color', [1, 1, 1]);

% Product details
products = {'Ice Cream', 'Croissant', 'Chocolate', 'Popcorn', 'Chips', 'Macarons', ...
            'Apple Juice', 'Milk', 'Soda', 'Biscuit', 'Donut', 'Sushi'};
prices = [5.00, 4.50, 6.00, 3.00, 3.50, 7.00, 4.00, 3.00, 2.50, 2.50, 3.00, 8.00];
images = {'IceCream.png', 'Croissant.png', 'Chocolate.png', 'Popcorn.png', 'Chips.png', ...
          'Macarons.png', 'AppleJuice.png', 'Milk.png', 'Soda.png', ...
          'Biscuit.png', 'Donut.png', 'Sushi.png'};


    % Selected products and total price display
    uicontrol(selection_fig, 'Style', 'text', ...
              'Position', [750, 700, 200, 30], ...
              'String', 'Selected Products:', ...
              'FontSize', 12, ...
              'HorizontalAlignment', 'left', ...
              'BackgroundColor', [1, 1, 1]);

selectedList = uicontrol(selection_fig, 'Style', 'listbox', ...
                         'Position', [770, 470, 180, 180], ...
                         'String', selectedProducts);


    % Total price display
    totalText = uicontrol(selection_fig, 'Style', 'text', ...
                          'Position', [750, 400, 200, 30], ...
                          'String', sprintf('Total: %.2f €', totalPrice), ...
                          'FontSize', 12, ...
                          'BackgroundColor', [1, 1, 1]);

% Remove button
uicontrol(selection_fig, 'Style', 'pushbutton', ...
          'Position', [770, 350, 180, 40], ...
          'String', 'Remove Selected', ...
          'FontSize', 12, ...
          'Callback', @(src, event) remove_selected(selectedList, totalText, products, prices));

% Pay button
uicontrol(selection_fig, 'Style', 'pushbutton', ...
          'Position', [770, 300, 180, 40], ...
          'String', 'Pay', ...
          'FontSize', 12, ...
          'Callback', @(src, event) go_to_payment_screen());



    % Product grid
    cols = 4;
    rows = ceil(length(products) / cols);
    spacing_x = 200;
    spacing_y = 250;
    start_x = 50;
    start_y = 650;

    for i = 1:length(products)
        col = mod(i-1, cols);
        row = floor((i-1) / cols);

        % Product image
        axes('Units', 'pixels', 'Position', [start_x + col * spacing_x, start_y - row * spacing_y, 120, 120]);
        try
            imshow(images{i});
        catch
            warning('Image missing: %s', images{i});
            rectangle('Position', [0, 0, 1, 1], 'FaceColor', [0.8, 0.8, 0.8]);
            text(0.5, 0.5, 'Image Missing', 'HorizontalAlignment', 'center', ...
                 'FontSize', 10, 'FontWeight', 'bold', 'Color', [1, 0, 0]);
        end
        axis off;

        % Product name
        uicontrol(selection_fig, 'Style', 'text', ...
                  'Position', [start_x + col * spacing_x, start_y - row * spacing_y - 30, 120, 20], ...
                  'String', lower(products{i}), ...
                  'FontSize', 12, ...
                  'FontWeight', 'bold', ...
                  'HorizontalAlignment', 'center', ...
                  'BackgroundColor', [1, 1, 1]);

        % Product price
        uicontrol(selection_fig, 'Style', 'text', ...
                  'Position', [start_x + col * spacing_x, start_y - row * spacing_y - 60, 120, 20], ...
                  'String', sprintf('%.2f €', prices(i)), ...
                  'FontSize', 10, ...
                  'HorizontalAlignment', 'center', ...
                  'BackgroundColor', [1, 1, 1]);

        % Select button
        uicontrol(selection_fig, 'Style', 'pushbutton', ...
                  'Position', [start_x + col * spacing_x, start_y - row * spacing_y - 90, 120, 30], ...
                  'String', 'Select', ...
                  'Callback', @(src, event) selectProduct(products{i}, prices(i), selectedList, totalText));
    end
end

function selectProduct(product, price, selectedList, totalText)
    global totalPrice selectedProducts;
    selectedProducts{end+1} = product;
    totalPrice = totalPrice + price;
    set(selectedList, 'String', selectedProducts);
    set(totalText, 'String', sprintf('Total: %.2f €', totalPrice));
    fprintf('Product Selected: %s, Current Total: %.2f\n', product, totalPrice);
end

function remove_selected(selectedList, totalText, products, prices)
    global totalPrice selectedProducts;
    selectedIndex = get(selectedList, 'Value');
    if selectedIndex > 0 && selectedIndex <= length(selectedProducts)
        removedProduct = selectedProducts{selectedIndex};
        removedPrice = prices(strcmp(products, removedProduct));
        selectedProducts(selectedIndex) = [];
        totalPrice = totalPrice - removedPrice;
        set(selectedList, 'String', selectedProducts);
        set(totalText, 'String', sprintf('Total: %.2f €', totalPrice));
        if selectedIndex > length(selectedProducts)
            set(selectedList, 'Value', max(1, length(selectedProducts)));
        end
    else
        msgbox('No product selected for removal!', 'Error', 'error');
    end
end
function go_to_payment_screen()
    global totalPrice;

    % Create the Payment Screen
    payment_fig = figure('Name', 'Payment Screen', 'Position', [100, 100, 1200, 700], 'Color', [1, 1, 1]);

    % Header Information
    uicontrol(payment_fig, 'Style', 'text', ...
              'Position', [50, 630, 400, 30], ...
              'String', sprintf('Total Price: %.2f €', totalPrice), ...
              'FontSize', 16, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);

    uicontrol(payment_fig, 'Style', 'text', ...
              'Position', [50, 590, 400, 30], ...
              'String', 'Total Paid: 0.00 €', ...
              'FontSize', 14, 'Tag', 'TotalPaid', 'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);

    uicontrol(payment_fig, 'Style', 'text', ...
              'Position', [50, 550, 400, 30], ...
              'String', sprintf('Remaining: %.2f €', totalPrice), ...
              'FontSize', 14, 'Tag', 'Remaining', ...
              'ForegroundColor', [1, 0, 0], 'HorizontalAlignment', 'left', 'BackgroundColor', [1, 1, 1]);

    % Payment Progress Bar
    uicontrol(payment_fig, 'Style', 'text', ...
              'Position', [500, 580, 200, 30], ...
              'String', 'Payment Progress', ...
              'FontSize', 12, 'HorizontalAlignment', 'center', 'BackgroundColor', [1, 1, 1]);

    % Progress Bar Container (Background Frame)
    uicontrol(payment_fig, 'Style', 'text', ...
              'Position', [500, 550, 200, 20], ...
              'BackgroundColor', [0.8, 0.8, 0.8], ...
              'Tag', 'ProgressBarBackground');

    % Payment Progress Bar (Dynamic)
    progress_bar = uicontrol(payment_fig, 'Style', 'text', ...
                             'Position', [500, 550, 0, 20], ...
                             'BackgroundColor', [0, 0.8, 0], ...
                             'Tag', 'ProgressBar');

    % Coin and Note Buttons with Images
    euro_values = [0.05, 0.10, 0.20, 0.50, 1, 2, 10, 20, 50];
    euro_images = {'5Cent.png', '10Cent.png', '20Cent.png', '50Cent.png', ...
                   '1Euro.png', '2Euro.png', '10Euro.png', '20Euro.png', '50Euro.png'};

    % Layout Parameters
    cols = 5; % Number of columns for the first row
    spacing_x = 180; % Horizontal spacing
    spacing_y = 200; % Vertical spacing
    start_x = 100; % Adjusted Start X position
    start_y_row1 = 400; % Adjusted Y position for the first row
    start_y_row2 = 150; % Adjusted Y position for the second row

    % First 5 coins in the first row
    for i = 1:5
        col = i - 1; % Column index (0-based)

        % Coin/Note Image
        axes('Units', 'pixels', ...
             'Position', [start_x + col * spacing_x, start_y_row1, 60, 60]);
        try
            coin_img = imread(euro_images{i});
            imshow(coin_img, 'Border', 'tight');
        catch
            warning('Image missing: %s', euro_images{i});
            rectangle('Position', [0, 0, 1, 1], 'FaceColor', [0.8, 0.8, 0.8]);
            text(0.5, 0.5, '?', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', [1, 0, 0]);
        end
        axis off;

        % Coin/Note Button
        uicontrol(payment_fig, 'Style', 'pushbutton', ...
                  'Position', [start_x + col * spacing_x - 10, start_y_row1 - 50, 80, 40], ...
                  'String', sprintf('%.2f €', euro_values(i)), ...
                  'FontSize', 10, ...
                  'Callback', @(src, event) add_money(euro_values(i), totalPrice, progress_bar));
    end


    for i = 6:9
        col = i - 6; % Column index (0-based)

        % Coin/Note Image
        axes('Units', 'pixels', ...
             'Position', [start_x + col * spacing_x, start_y_row2, 60, 60]);
        try
            coin_img = imread(euro_images{i});
            imshow(coin_img, 'Border', 'tight');
        catch
            warning('Image missing: %s', euro_images{i});
            rectangle('Position', [0, 0, 1, 1], 'FaceColor', [0.8, 0.8, 0.8]);
            text(0.5, 0.5, '?', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', [1, 0, 0]);
        end
        axis off;

        % Coin/Note Button
        uicontrol(payment_fig, 'Style', 'pushbutton', ...
                  'Position', [start_x + col * spacing_x - 10, start_y_row2 - 50, 80, 40], ...
                  'String', sprintf('%.2f €', euro_values(i)), ...
                  'FontSize', 10, ...
                  'Callback', @(src, event) add_money(euro_values(i), totalPrice, progress_bar));
    end
end


function add_money(amount, total_price, progress_bar)
    persistent total_paid;
    if isempty(total_paid)
        total_paid = 0;
    end

    % Update total paid
    total_paid = total_paid + amount;

    % Calculate remaining
    remaining = total_price - total_paid;
    totalPaidLabel = findobj('Tag', 'TotalPaid');
    remainingLabel = findobj('Tag', 'Remaining');

    set(totalPaidLabel, 'String', sprintf('Total Paid: %.2f €', total_paid));
    set(remainingLabel, 'String', sprintf('Remaining: %.2f €', max(0, remaining)));

    % Update progress bar
    max_bar_width = 200; % Progress bar maximum width
    progress_width = max(0, min(max_bar_width, max_bar_width * (total_paid / total_price))); % Calculate progress bar width
    set(progress_bar, 'Position', [500, 550, progress_width, 20]);

    % Change color to green if payment is complete
    if remaining <= 0
        set(remainingLabel, 'ForegroundColor', [0, 0.8, 0]); % Green
        if remaining < 0
            % Calculate change
            change = abs(remaining);
            custom_success_message(change);
        else
            custom_success_message(0);
        end

        % Reset total_paid after successful payment
        total_paid = 0; % Reset persistent variable
    else

if remaining <= 0
    set(remainingLabel, 'ForegroundColor', [0, 0.8, 0]); % Green
    if remaining < 0
        % Calculate change
        change = abs(remaining);
        custom_success_message(change);
    else
        custom_success_message(0);
    end

    % Reset total_paid after successful payment
    total_paid = 0; % Reset persistent variable
end


        % Change color dynamically based on remaining amount
        if remaining > total_price * 0.5
            set(remainingLabel, 'ForegroundColor', [1, 0, 0]); % Red
        elseif remaining > 0
            set(remainingLabel, 'ForegroundColor', [1, 0.5, 0]); % Orange
        end
    end
end


function custom_success_message(change)
    % Create a custom figure
    msg_fig = figure('Name', 'Success', 'Position', [500, 400, 300, 200], ...
                     'Color', [0.9, 0.95, 1], 'MenuBar', 'none', 'NumberTitle', 'off');

    % Add an icon
    axes('Position', [0.1, 0.6, 0.2, 0.3]);
    try
        imshow('SuccessIcon.png');
    catch
        % Default placeholder if image is missing
        rectangle('Position', [0, 0, 1, 1], 'FaceColor', [0.8, 0.8, 0.8]);
        text(0.5, 0.5, '✔', 'HorizontalAlignment', 'center', ...
             'FontSize', 24, 'FontWeight', 'bold', 'Color', [0, 0.8, 0]);
    end
    axis off;

    % Add message text
    uicontrol(msg_fig, 'Style', 'text', ...
              'Position', [100, 120, 180, 40], ...
              'String', 'Payment Complete!', ...
              'FontSize', 14, 'FontWeight', 'bold', 'BackgroundColor', [0.9, 0.95, 1], ...
              'ForegroundColor', [0, 0.5, 0]);

    % Add change information
    uicontrol(msg_fig, 'Style', 'text', ...
              'Position', [100, 80, 180, 30], ...
              'String', sprintf('Change: %.2f €', change), ...
              'FontSize', 12, 'FontWeight', 'normal', 'BackgroundColor', [0.9, 0.95, 1], ...
              'ForegroundColor', [0, 0, 0.5]);

    % Add an OK button
    uicontrol(msg_fig, 'Style', 'pushbutton', ...
              'Position', [110, 30, 80, 30], ...
              'String', 'OK', ...
              'FontSize', 12, ...
              'Callback', @(src, event) close(msg_fig));
end


