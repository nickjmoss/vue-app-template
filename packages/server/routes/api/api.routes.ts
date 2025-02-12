import {
    FastifyInstance,
    FastifyPluginOptions,
    FastifyRegisterOptions,
} from 'fastify';

export const apiRoutes = function (
    fastify: FastifyInstance,
    _: FastifyRegisterOptions<FastifyPluginOptions>,
    next: () => void,
) {
    fastify.get('/ping', async () => {
        return 'pong';
    });

    next();
};
