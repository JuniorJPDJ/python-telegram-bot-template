import asyncio
import logging
import os

from telethon import TelegramClient

import yaml

def env_constructor(loader, node):
    return os.environ.get(loader.construct_scalar(node), None)

async def main(config):
    logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=config['log_level'])
    # logger = logging.getLogger(__name__)

    client = TelegramClient(**config['telethon_settings'])
    print("Starting")
    await client.start(bot_token=config['bot_token'])
    print("Started")

    # TODO: Bot ;)

    async with client:
        print("Good morning!")
        await client.run_until_disconnected()


if __name__ == '__main__':
    yaml.SafeLoader.add_constructor("!env", env_constructor)
    with open("config.yml", 'r') as f:
        config = yaml.safe_load(f)
    asyncio.get_event_loop().run_until_complete(main(config))
