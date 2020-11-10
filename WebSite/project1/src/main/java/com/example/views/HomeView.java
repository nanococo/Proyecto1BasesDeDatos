package com.example.views;

import com.example.pojos.Account;
import com.example.pojos.BankAccount;
import com.example.services.Services;
import com.vaadin.flow.component.button.Button;
import com.vaadin.flow.component.button.ButtonVariant;
import com.vaadin.flow.component.dependency.CssImport;
import com.vaadin.flow.component.grid.Grid;
import com.vaadin.flow.component.html.H1;
import com.vaadin.flow.component.orderedlayout.HorizontalLayout;
import com.vaadin.flow.component.orderedlayout.VerticalLayout;
import com.vaadin.flow.router.Route;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.List;

@Route(value = "home")
@CssImport("./styles/shared-styles.css")
public class HomeView extends VerticalLayout {

    public HomeView(@Autowired Services service){
        H1 header = new H1("Bienvenido al Banco");

        HorizontalLayout horizontalLayout = new HorizontalLayout();
        Button button = new Button("Editar Beneficiarios");
        button.addThemeVariants(ButtonVariant.LUMO_PRIMARY);
        Button button2 = new Button("Consultar Estados de Cuenta");
        button2.addThemeVariants(ButtonVariant.LUMO_PRIMARY);
        horizontalLayout.add(button, button2);

        //Paragraph p1 = new Paragraph("")

        Grid<Account> dataGrid = new Grid<>(Account.class);
        dataGrid.setItems(service.getAccounts());
        //dataGrid.getColumnByKey("Balance").
        //dataGrid.setColumns("ownerName", "accountID", "amount");
        //dataGrid.addColumn("options").setEditorComponent(new Button("click me"));

        add(header, horizontalLayout, dataGrid);
    }
}
