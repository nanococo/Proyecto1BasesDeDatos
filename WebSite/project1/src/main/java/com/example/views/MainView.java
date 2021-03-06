package com.example.views;

import com.example.services.GreetService;
import com.vaadin.flow.component.Key;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.button.ButtonVariant;
import com.vaadin.flow.component.dependency.CssImport;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.notification.Notification;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.component.textfield.PasswordField;
import com.vaadin.flow.component.textfield.TextField;
import com.vaadin.flow.router.Route;
import com.vaadin.flow.server.PWA;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * A sample Vaadin view class.
 * <p>
 * To implement a Vaadin view just extend any Vaadin component and
 * use @Route annotation to announce it in a URL as a Spring managed
 * bean.
 * Use the @PWA annotation make the application installable on phones,
 * tablets and some desktop browsers.
 * <p>
 * A new instance of this class is created for every new user and every
 * browser tab/window.
 */
@Route
@PWA(name = "Vaadin Application",
        shortName = "Vaadin App",
        description = "This is an example Vaadin application.",
        enableInstallPrompt = false)
@CssImport("./styles/shared-styles.css")
@CssImport(value = "./styles/vaadin-text-field-styles.css", themeFor = "vaadin-text-field")
public class MainView extends VerticalLayout {

    /**
     * Construct a new Vaadin view.
     * <p>
     * Build the initial UI state for the user accessing the application.
     *
     * @param service The message service. Automatically injected Spring managed bean.
     */
    public MainView(@Autowired GreetService service) {

        H1 h1 = new H1("Bienvenido");

        // Use TextField for standard text input
        TextField usernameField = new TextField("Username");
        usernameField.addThemeName("bordered");

        PasswordField passwordField = new PasswordField("Password");
        passwordField.addThemeName("bordered");

        // Button click listeners can be defined as lambda expressions
//        Button button = new Button("Login", e -> Notification.show(service.greet(usernameField.getValue())));
        Button button = new Button("Login", e -> {

            if(!usernameField.getValue().equals("") && !passwordField.getValue().equals("")){
                if(service.login(usernameField.getValue(), passwordField.getValue())){
                    Notification.show("Welcome");
                    service.navigate();

                } else {
                    Notification.show("Your account doesn't exist");
                }
            } else {
                Notification.show("Username or Password not provided");
            }

        });

        // Theme variants give you predefined extra styles for components.
        // Example: Primary button has a more prominent look.
        button.addThemeVariants(ButtonVariant.LUMO_PRIMARY);

        // You can specify keyboard shortcuts for buttons.
        // Example: Pressing enter in this view clicks the Button.

        button.addClickShortcut(Key.ENTER);
        //button.addClassName("centered-content");

        // Use custom CSS classes to apply styling. This is defined in shared-styles.css.
        addClassName("centered-content");

        add(h1, usernameField, passwordField, button);
    }

}
