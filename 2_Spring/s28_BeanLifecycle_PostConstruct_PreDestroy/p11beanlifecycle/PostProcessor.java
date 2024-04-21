package cydavidh.springdemo.p11beanlifecycle;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.stereotype.Component;

@Component
class PostProcessor implements BeanPostProcessor {

    @Override
    public Object postProcessBeforeInitialization(
            Object bean, String beanName) throws BeansException {

//        System.out.println("Before initialization: " + beanName);

        return BeanPostProcessor.super
                .postProcessBeforeInitialization(bean, beanName);
    }

    @Override
    public Object postProcessAfterInitialization(
            Object bean, String beanName) throws BeansException {

//        System.out.println("After initialization: " + beanName);

        return BeanPostProcessor.super
                .postProcessAfterInitialization(bean, beanName);
    }
}