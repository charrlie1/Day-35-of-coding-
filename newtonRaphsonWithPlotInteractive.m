function root = newtonRaphsonWithPlotInteractive()
    
    prompt = {'Enter the function f(x):', ...
              'Enter initial guess x0:', ...
              'Enter tolerance:', ...
              'Enter maximum iterations:'};
    dlg_title = 'Newton-Raphson Method Inputs';
    num_lines = 1;
    defaultans = {'x.^2 - 4', '2', '1e-6', '100'};
    answer = inputdlg(prompt, dlg_title, num_lines, defaultans);

    if isempty(answer)
        disp('User cancelled input.');
        return;
    end

    func_str = answer{1};
    x0 = str2double(answer{2});
    tol = str2double(answer{3});
    max_iter = str2double(answer{4});

    
    f = str2func(['@(x) ' func_str]);

    % by central difference
    df = @(x) (f(x + 1e-7) - f(x - 1e-7)) / (2 * 1e-7);

    
    x = x0;
    x_vals = x;
    f_vals = f(x);

    
    for i = 1:max_iter
        fx = f(x);
        dfx = df(x);
        if abs(dfx) < 1e-10
            errordlg('Derivative too small. Method failed.', 'Error');
            return;
        end

        x_next = x - fx / dfx;
        x_vals(end+1) = x_next;
        f_vals(end+1) = f(x_next);

        if abs(x_next - x) < tol
            msgbox(sprintf('Converged in %d iterations.', i), 'Success');
            root = x_next;
            break;
        end

        x = x_next;
    end

    if i == max_iter && abs(x_next - x) >= tol
        warndlg('Max iterations reached without convergence.', 'Warning');
        root = x_next;
    end

    
    figure;
    x_range = linspace(min(x_vals)-1, max(x_vals)+1, 1000);
    plot(x_range, f(x_range), 'b-', 'LineWidth', 1.5);
    hold on;
    plot(x_vals, f_vals, 'ro-', 'LineWidth', 1, 'MarkerFaceColor', 'r');
    plot(root, f(root), 'gs', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    title('Newton-Raphson Method (NRI) ');
    xlabel('x'); ylabel('f(x)');
    legend('Function f(x)', 'Iteration Steps', 'Final Root', 'Location', 'best');
    grid on;

    
    text(x0, f(x0), sprintf('x_0 = %.2f', x0), ...
         'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');

    hold off;

    % Output results to console
    fprintf('Approximate root: %.8f\n', root);
    fprintf('Function value at root: %.2e\n', f(root));
end