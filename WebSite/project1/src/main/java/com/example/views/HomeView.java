package com.example.views;

import com.example.pojos.Account;
import com.example.services.Services;
import com.example.services.singletons.Common;
import com.example.views.forms.AddBeneficiaryForm;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.button.ButtonVariant;
import com.vaadin.flow.component.dependency.CssImport;
import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.notification.Notification;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.Route;
import org.springframework.beans.factory.annotation.Autowired;

@Route(value = "home")
@CssImport("./styles/shared-styles.css")
public class HomeView extends VerticalLayout {

    private final Grid<Account> dataGrid = new Grid<>(Account.class);
    private final AddBeneficiaryForm addBeneficiaryForm;

    public HomeView(@Autowired Services service){
        addBeneficiaryForm = new AddBeneficiaryForm(service);
        setSizeFull();


        H1 header = new H1("Bienvenido al Banco");

        HorizontalLayout horizontalLayout = new HorizontalLayout();
        Button button = new Button("Beneficiarios");
        button.addThemeVariants(ButtonVariant.LUMO_PRIMARY);
        button.setEnabled(false);

        button.addClickListener(buttonClickEvent -> service.navigateToBeneficiaries());

        Button button2 = new Button("Consultar Estados de Cuenta");
        button2.addThemeVariants(ButtonVariant.LUMO_PRIMARY);
        button2.setEnabled(false);

        button2.addClickListener(buttonClickEvent -> service.navigateToStatements());

        horizontalLayout.add(button, button2);


        dataGrid.setItems(service.getAccounts());
        dataGrid.setSelectionMode(Grid.SelectionMode.SINGLE);
        dataGrid.setSizeFull();
        dataGrid.asSingleSelect().addValueChangeListener(event -> {
            Common.accountId = event.getValue().getId();
            Notification.show(String.valueOf(Common.accountId));
            button2.setEnabled(true);
            button.setEnabled(true);
        });

        dataGrid.getColumns().forEach(col -> col.setAutoWidth(true));


        HorizontalLayout horizontalLayout1 = new HorizontalLayout(dataGrid, addBeneficiaryForm);
        horizontalLayout1.setSizeFull();

        setSizeFull();
        add(header, horizontalLayout, dataGrid);
    }
}
